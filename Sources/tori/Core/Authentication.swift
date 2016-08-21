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

class AuthenticationRouter {
    
    private let userCollection = db["User"]

    init() {
                
        // MARK: - Login
        _ = router.all("/api/log*",
                   middleware: [
                    AllRemoteOriginMiddleware(),
                    BodyParser(),
                    CheckRequestIsValidJson()
            ])
        
        router.post("/api/login") {
            req, res, next in
            
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
            
            var user = User()
            user.map(fromBSON: userData)
            
            // generate an unique token
            let userToken = NSUUID().uuidString
            
            var newUser = user
            newUser.token = userToken
            
            // update new token
            try self.userCollection.update(matching: user.bson, to: newUser.bson)
            
            let responseJson = JSON([
                "status": "ok",
                "token": userToken,
                "user": userName
                ])
            
            res.json(withJson: responseJson)
            
            next()
        }
        
        // MARK: - Registration
        _ = router.all("/api/register",
                   middleware: [
                    AllRemoteOriginMiddleware(),
                    BodyParser(),
                    CheckRequestIsValidJson()
                ]
        )
        router.post("/api/register") {
            req, res, next in
            
            guard isRegistrationEnabled() else {
                res.error(withMsg: "Registration disabled")
                return
            }
            
            // TODO: implement registration, figure out how to manage default role
            
        }
        
        // MARK: - Logout
        router.all("/api/logout", middleware: TokenAuthentication())
        router.get("/api/logout") {
            req, res, next in
            
            guard let user = req.getUser() else {
                res.error(withMsg: "user not found")
                return
            }
            
            // remove token
            var newUser = user
            newUser.token = ""
            
            // store to db
            try! self.userCollection.update(matching: user.bson, to: newUser.bson)
            
            let responseJson = JSON([
                "status": "ok",
                "action": "logout"])
            
            res.json(withJson: responseJson)

            next()

        }

    }
}
