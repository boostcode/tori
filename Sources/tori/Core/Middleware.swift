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
    /// validate current json request
    /// Handle an incoming HTTP request.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the HTTP request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       HTTP request
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    ///
    /// - Throws: Any `ErrorType`. If an error is thrown, processing of the request
    ///          is stopped, the error handlers, if any are defined, will be invoked,
    ///          and the user will get a response with a status code of 500.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {

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
    /// token based authentication
    /// Handle an incoming HTTP request.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the HTTP request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       HTTP request
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    ///
    /// - Throws: Any `ErrorType`. If an error is thrown, processing of the request
    ///          is stopped, the error handlers, if any are defined, will be invoked,
    ///          and the user will get a response with a status code of 500.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let userToken = request.headers["Tori-Token"] else {
            response.error(withMsg: "missing Tori-Token")
            return
        }
        
        let userCollection = db["User"]
        
        guard (try! userCollection.findOne(matching: "token" == userToken)) != nil else {
            response.error(withMsg: "invalid Tori-Token")
            return
        }
        
        request.userInfo.updateValue(userToken, forKey: "Tori-Token")
        
        next()
    }

}

class AdminOnly: RouterMiddleware {
    /// Handle an incoming HTTP request.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the HTTP request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       HTTP request
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    ///
    /// - Throws: Any `ErrorType`. If an error is thrown, processing of the request
    ///          is stopped, the error handlers, if any are defined, will be invoked,
    ///          and the user will get a response with a status code of 500.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        // FIXME: update or remove according UGO
        
        /*let userRole = Role(rawValue:request.userInfo["Tori-Role"] as! Int)
         
         if userRole != .Admin {
         response.error(withMsg: "user has no admin rights")
         return
         }*/
        
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
