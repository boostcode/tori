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

class Route {

    var slug = ""
    var model: String {
        return self.slug.capitalized
    }
    var collection: MongoKitten.Collection {
        return db[self.model]
    }
    // manages access to the collection
    var acl: [[Role: ACL]]

    // contains the keys that need to be skipped on response
    var skip: [String]


    init(withPath slug: String, withACL acl: [[Role: ACL]], andSkipping skip: [String] = []) {
        self.slug = slug
        self.acl = acl
        self.skip = skip
    }

    func enableRoutes() {

        // sets all headers & validators
        router.all("/api/\(slug)*", middleware: AllRemoteOriginMiddleware())
        router.all("/api/\(slug)*", middleware: BodyParser())
        router.all("/api/\(slug)*", middleware: CheckRequestIsValidJson())
        router.all("/api/\(slug)*", middleware: TokenAuthentication())
        router.all("/api/\(slug)*", middleware: GetUser())

        // GET all items
        router.get("/api/\(slug)") {
            req, res, next in
            let userRole =  Role(rawValue: req.userInfo["role"] as! Int)

            for rule in self.acl {
                if (rule.index(forKey: userRole!) != nil) {
                    if rule.values.first?.read == .All {

                        let items = try! self.collection.find()
                        let allItems = Array(items)

                        // TODO: items needs to be filtered according skip

                        res.json(withJson: JSON([
                                                    "status": "ok",
                                                    //"\(self.slug)": allItems
                            ]))

                    }
                }
            }

            res.error(withMsg: "user has no permission")

        }

        // GET single item with Id
        router.get("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.params["id"] else {
                res.error(withMsg: "missing id")
                return
            }

        }

        // POST creates a new item
        router.post("/api/\(slug)") {
            req, res, next in
        }

        // PUT updates an existing item
        router.put("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.params["id"] else {
                res.error(withMsg: "missing id")
                return
            }

        }

        // DELETE removes an existing item
        router.delete("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.params["id"] else {
                res.error(withMsg: "missing id")
                return
            }

        }
    }
}