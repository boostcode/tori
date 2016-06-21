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
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        if request.method != RouterMethod.Get {

            guard let body = request.body else {
                response.error(withMsg: "request is missing body")
                return
            }

            guard case let .Json(json) = body else {
                response.error(withMsg: "request is not in json format")
                return
            }
        }

        next()

    }
}

class TokenAuthentication: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        guard let userToken = request.headers["Tori-Token"] else {
            response.error(withMsg: "missing Tori-Token")
            return
        }

        request.userInfo.updateValue(userToken, forKey: "Tori-Token")

        guard let userName = request.headers["Tori-User"] else {
            response.error(withMsg: "missing Tori-User")
            return
        }

        request.userInfo.updateValue(userName, forKey: "Tori-User")

        let userCollection = db["User"]

        if try! userCollection.count(matching: "username" == userName && "token" == userToken) == 0 {
            response.error(withMsg: "invalid Tori-Token")
            return
        }

        next()
    }
}

class GetUser: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        guard let userName = request.userInfo["Tori-User"] as? String else {
            response.error(withMsg: "missing Tori-User")
            return
        }
        let userCollection = db["User"]
        let user = try! userCollection.findOne(matching: "username" == userName)

        request.userInfo.updateValue(user!["role"].int, forKey: "Tori-Role")

        next()
    }
}

class AdminOnly: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        let userRole = Role(rawValue:request.userInfo["Tori-Role"] as! Int)

        if userRole != .Admin {
            response.error(withMsg: "user has no admin rights")
            return
        }

        next()

    }
}


// MARK: - Response
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        response.setHeader("Access-Control-Allow-Origin", value: "*")
        response.setHeader("Content-Type", value: "application/json; charset=utf-8")
        next()
        
    }
}
