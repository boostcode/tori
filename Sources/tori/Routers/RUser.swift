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

// logger
import HeliumLogger
import LoggerAPI

//import CryptoSwift

func routerUser() {

  router.all("/api/user*", middleware: BodyParser())
  router.all("/api/user*", middleware: TokenAuthentication())

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
  router.all("/api/log*", middleware: BodyParser())

  router.post("/api/login") {
    req, res, next in

    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

    guard let body = req.body else {
      do {
        try res.status(HttpStatusCode.BAD_REQUEST).end()
      } catch {
        Log.error("Login / Failed to send response")
      }
      Log.error("Login / Missing body")
      return
    }

    print(body)

    // find how to read body data
    /*guard let json = body.asJson() else {
      do {
        try res.status(HttpStatusCode.BAD_REQUEST).end()
      } catch {
        Log.error("Login / Failed to send response")
      }
      Log.error("Login / Body is invalid JSON")
      return
    }

    let userName = json["username"].stringValue
    let userPassword = json["password"].stringValue

    if userName == "" || userPassword == "" {
      do {
        try res.status(HttpStatusCode.OK).send("{ \"login\": \"failed\" }").end()
        Log.error("Login / Missing credentials")
      } catch {
        Log.error("Failed to send response")
      }
    } else {
      /*var query = BSON.Document()
      query["username"] = .String(userName)
      // TODO: need to SHA256 the password as soon CryptoSwift start working back
      query["password"] = .String(userPassword)

      // FIX: crash here! :x
      let login = userCollection.query(query)
      //print(login)
      if login.count == 0 {
        do {
          try res.status(HttpStatusCode.OK).sendJson("{ \"login\": \"failed\" }").end()
          Log.error("Login / User not found")
        } catch {
          Log.error("Login / Failed to send response")
        }
      } else {
        do {
          try res.status(HttpStatusCode.OK).sendJson("{ \"login\": \"ok\", \"userId\": \"\", \"token\": \"\" }").end()
          Log.debug("Login / Is valid user")
        } catch {
          Log.error("Login / Failed to send response")
        }
      }*/

    }*/

  }

  // logout user
  router.get("/api/logout") {
    req, res, next in

    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }
}
