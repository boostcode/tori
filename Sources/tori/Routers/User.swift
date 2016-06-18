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

func routerUser() {

    router.all("/api/user*", middleware: AllRemoteOriginMiddleware())
    router.all("/api/user*", middleware: BodyParser())
    router.all("/api/user*", middleware: CheckRequestIsValidJson())
    router.all("/api/user*", middleware: TokenAuthentication())
    router.all("/api/user*", middleware: AdminOnly())


    // gets all the users
    router.get("/api/user") {
        req, res, next in
        res.setHeader("Content-Type", value: "application/json; charset=utf-8")
        // TODO: remove password, token & push
        do {
            //try res.status(HttpStatusCode.OK).sendJson("").end()
            try res.status(HttpStatusCode.OK).send("").end()
        } catch {
            Log.error("Failed to send response")
        }
    }

    // gets information for a single user
    router.get("/api/user/:id") {
        req, res, next in
        let userId = req.params["id"]
        // TODO: remove password, token & push

        res.setHeader("Content-Type", value: "application/json; charset=utf-8")

    //let user = User(bson: userCollection.getById(userId!)!)
    do {
      //try res.status(HttpStatusCode.OK).send(json: ).end()
      try res.status(HttpStatusCode.OK).send("").end()
    } catch {
      Log.error("Failed to send response")
    }
  }

  // creates new user
  router.post("/api/user") {
    req, res, next in
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

  // updates an existing user
  router.put("/api/user/:id") {
    req, res, next in
    let userId = req.params["id"]

    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

  // deletes an existing user
  router.delete("/api/user/:id") {
    req, res, next in
    let userId = req.params["id"]

    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

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

    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }
}
