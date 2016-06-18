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

import MongoKitten
import SwiftyJSON

// logger
import HeliumLogger
import LoggerAPI

//import CryptoSwift

// token authentication
class TokenAuthentication: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        let userToken = request.headers["UserToken"]
        let userId = request.headers["UserId"]

        // first check if token and userId exists
        if userToken == nil || userId == nil {
            Log.error("Autentication / Failed, missing token and userId")
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "missing token or userId"
                                     ]))
                .end()

        } else {

            let userCollection = db["Users"]

            if try! userCollection.count(matching: "username" == userId! && "token" == userToken!) == 0 {
                Log.error("Autentication / Failed, wrong credentials")
                try! response
                    .status(.OK)
                    .send(json: JSON([
                                         "status": "error",
                                         "message": "wrong token or userId"
                        ]))
                    .end()
            }
        }

        next()
    }
}

// enforce only admin user to manage those routes
class AdminOnly: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
        let userToken = request.headers["UserToken"]
        let userId = request.headers["UserId"]
        
        let userCollection = db["Users"]
        
        if try! userCollection.count(matching: "username" == userId! && "token" == userToken! && "role.name" == "admin") == 0 {
            Log.error("Authentication / Failed, this user has no admin rights")
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "user has no admin rights"
                    ]))
                .end()
        }
        
        next()
        
    }
}
