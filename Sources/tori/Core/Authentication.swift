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

import ToriAllowRemoteOrigin


// logger
import HeliumLogger
import LoggerAPI

class AuthenticationRouter {
    
    private let userCollection = db["User"]

    init() {
                
        // MARK: - Login
        _ = router.all("/api/log*",
                   middleware: [
                    AllowRemoteOrigin(),
                    BodyParser(),
                    CheckRequestIsValidJson()
            ])
        
        router.post("/api/login") { req, res, _ in
            
            guard case let .json(json) = req.body! else {
                res.error(withMsg: "request is not in json format")
                return
            }
            
            guard let userName = json["username"].string else {
                res.error(withMsg: "missing username value")
                return
            }
            
            guard let userPassword = json["password"].string else {
                res.error(withMsg: "missing password value")
                return
            }
            
            guard let userData = try! self.userCollection.findOne(matching: "username" == userName && "password" == userPassword.md5) else {
                res.error(withMsg: "wrong user or password provided")
                return
            }
            
            let user = User(bson: userData)
            
            // generate an unique token
            let userToken = NSUUID().uuidString
            
            var newUser = user
            newUser.bson["token"] = .string(userToken)
            
            // update new token
            try self.userCollection.update(matching: user.bson, to: newUser.bson)
            
            let responseJson = JSON([
                "status": "ok",
                "token": userToken,
                "user": userName
                ])
            
            res.json(withJson: responseJson)
            
        }
        
        // MARK: - Registration
        _ = router.all("/api/register",
                   middleware: [
                    AllowRemoteOrigin(),
                    BodyParser(),
                    CheckRequestIsValidJson()
                ]
        )
        router.post("/api/register") { req, res, _ in
            
            guard isRegistrationEnabled() else {
                res.error(withMsg: "Registration disabled")
                return
            }
            
            // TODO: implement registration, figure out how to manage default role
            
        }
        
        // MARK: - Logout
        router.all("/api/logout", middleware: TokenAuthentication())
        router.get("/api/logout") { req, res, _ in
            
            guard let user = req.getUser() else {
                res.error(withMsg: "user not found")
                return
            }
            
            // remove token
            var newUser = user
            newUser.bson["token"] = .string("")
            
            // store to db
            try! self.userCollection.update(matching: user.bson, to: newUser.bson)
            
            let responseJson = JSON([
                "status": "ok",
                "action": "logout"])
            
            res.json(withJson: responseJson)

        }

    }
}
