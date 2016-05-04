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


func routerRole() {

  router.all("/api/role/*", middleware: BodyParser())
  router.all("/api/role/*", middleware: TokenAuthentication())
  router.all("/api/role/*", middleware: AdminOnly())

  // gets all the roles
  router.get("/api/role") {
    req, res, next in
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

  // gets information for a single role
  router.get("/api/role/:id") {
    req, res, next in
    let roleId = req.params["id"]
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

  // creates new role
  router.post("/api/role") {
    req, res, next in
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")
  }

  // updates an existing role
  router.put("/api/role/:id") {
    req, res, next in
    let roleId = req.params["id"]
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }

  // deletes an existing role
  router.delete("/api/role/:id") {
    req, res, next in
    let roleId = req.params["id"]
    res.setHeader("Content-Type", value: "application/json; charset=utf-8")

  }
}
