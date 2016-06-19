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


func routerAuth() {

    // login user
    router.all("/api/log*", middleware: AllRemoteOriginMiddleware())
    router.all("/api/log*", middleware: BodyParser())
    router.all("/api/log*", middleware: CheckRequestIsValidJson())


    router.post("/api/login") {
        req, res, next in

        guard case let .Json(json) = req.body! else {
            return
        }

        guard let userName = json["username"].string else {
            try! res
                .status(.OK)
                .send(json: JSON([
                    "status": "error",
                    "message": "Request body has no username"
                ]))
            .end()
            return
        }

        guard let userPassword = json["password"].string else {
            try! res
                .status(.OK)
                .send(json: JSON([
                                 "status": "error",
                                 "message": "Request body has no password"
                ]))
                .end()
            return
        }

        let userCollection = db["Users"]

        let passwordMD5 = "\(userPassword.md5())"

        guard let user = try! userCollection.findOne(matching: "username" == userName && "password" == passwordMD5) else {
            try! res
                .status(.OK)
                .send(json: JSON([
                                 "status": "error",
                                 "message": "Wrong user/password provided"
                ]))
                .end()
            return
        }

        // TODO: Need to generate a token

        // TODO: convert user to json
        let responseJson = JSON([]) //JSON(user)

        try! res
            .status(.OK)
            .send(json: responseJson)
            .end()

  }

  // logout user
  router.get("/api/logout") {
    req, res, next in

    // TODO: revoke token

    // TODO: add response
  }
}
