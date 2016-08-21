/**
 * Copyright boostco.de 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

import Kitura
import KituraSys
import KituraNet

import SwiftyJSON

import MongoKitten

// logger
import HeliumLogger
import LoggerAPI

// MARK: - Quick handlers for response
extension RouterResponse {
    
    func error(withMsg msg: String) {
        Log.error("Route / \(msg)")
        try! self
            .status(.OK)
            .send(json: JSON([
                    "status": "error",
                    "message": msg
                ]))
        .end()
    }

    func json(withJson json: JSON) {

        try! self
            .status(.OK)
            .send(json: json)
        .end()
    }
}


// MARK: - Request
class CheckRequestIsValidJson: RouterMiddleware {
    // validate current json request
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        if request.method != RouterMethod.get {

            guard let body = request.body else {
                response.error(withMsg: "request is missing body")
                return
            }

            guard case .json(_) = body else {
                response.error(withMsg: "request is not in json format")
                return
            }
        }

        next()

    }
}

class TokenAuthentication: RouterMiddleware {
    // token based authentication
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        guard let userToken = request.headers["Tori-Token"] else {
            response.error(withMsg: "missing Tori-Token")
            return
        }

        let userCollection = db["User"]

        guard let user = try! userCollection.findOne(matching: "token" == userToken) else {
            response.error(withMsg: "invalid Tori-Token")
            return
        }

        request.userInfo.updateValue(userToken, forKey: "Tori-Token")

        next()
    }
}

class AdminOnly: RouterMiddleware {
    // shall pass only users with admin privileges
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        // FIXME: update or remove according UGO
        
        /*let userRole = Role(rawValue:request.userInfo["Tori-Role"] as! Int)
        
        if userRole != .Admin {
            response.error(withMsg: "user has no admin rights")
            return
        }*/
        
        next()
        
    }
}


class HasParameterId: RouterMiddleware {
    // shall pass only if an id is in querystring
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        guard let _ = request.parameters["id"] else {
            response.error(withMsg: "missing id in request")
            return
        }

        next()
        
    }

}

extension RouterRequest {
    func getUser() -> User? {
        
        guard let userToken = self.userInfo["Tori-Token"] as? String else { return nil }

        let userCollection = db["User"]

        guard let user = try! userCollection.findOne(matching: "token" == userToken) else {
            return nil
        }
        
        return User(bson: user)
    }
}
