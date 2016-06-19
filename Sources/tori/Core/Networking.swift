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


// MARK: - Request
class CheckRequestIsValidJson: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        guard let body = request.body else {
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "Request is missing body"
                    ]))
                .end()
            return
        }

        guard case let .Json(json) = body else {
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "Request body is not in json format"
                    ]))
                .end()
            return
        }

        next()

    }
}

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

class AdminOnly: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        let userToken = request.headers["UserToken"]
        let userId = request.headers["UserId"]

        let userCollection = db["Users"]


        // TODO: update Admin check
        if try! userCollection.count(matching: "username" == userId! && "token" == userToken! && "role" == "admin") == 0 {
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

class CheckPermission: RouterMiddleware {

    var acl: [[Role: ACL]]

    init(withACLRules acl: [[Role: ACL]]) {
        self.acl = acl
    }

    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        // TODO: manage permission check

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
