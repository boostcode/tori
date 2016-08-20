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

// document types
enum RouteDocumentType {
    case role
    case objectId
    case string
    case boolean
    case int
    case double
    case array
    case document
    case date
}

// route types
@objc enum RouteTypes: Int {
    case getAll
    case get
    case set
    case update
    case delete
}

// protocols
@objc protocol RouterDelegate {
    @objc optional func preHook(forType type: RouteTypes)
    @objc optional func postHook(forType type: RouteTypes)
}

class Route {

    var slug = ""
    var dbModelName: String {
        return self.slug.capitalized
    }
    var collection: MongoKitten.Collection {
        return db[self.dbModelName]
    }
    // manages access to the collection
    var acl: [ACLRuleElement]

    // manages the schema connected to the route
    var schema: [String: RouteDocumentType]

    // contains the keys that need to be skipped on response
    var blacklistedKeys: [String]
    
    // set delegate for routing hooks
    var delegate: RouterDelegate?


    init(withPath slug: String, withSchema schema:[String: RouteDocumentType], withACL acl: ACLRule, andBlacklistingKeys blacklistedKeys: [String] = []) {
        assert(slug.characters.count > 0, "Schema must contain at least a key")
        self.slug = slug
        assert(schema.count > 0, "Schema must contain at least a key")
        self.schema = schema
        assert(acl.rules.count > 0, "Acl must contain at least a rule")
        self.acl = acl.rules
        self.blacklistedKeys = blacklistedKeys
    }

    func bsonToDict(bson: Cursor<Document>) -> [String: AnyObject] {

        var dict = [String: AnyObject]()

        for item in bson {

            for obj in self.schema {

                // check for blacklisting
                if self.blacklistedKeys.contains(obj.key) {
                    break
                }

                switch obj.value {

                case .date:
                    dict[obj.key] = item[obj.key].string
                case .boolean:
                    dict[obj.key] = item[obj.key].bool
                case .double:
                    dict[obj.key] = item[obj.key].double
                case .int:
                    dict[obj.key] = item[obj.key].int
                case .objectId:
                    dict[obj.key] = item[obj.key].objectIdValue!.hexString
                case .role:
                    dict[obj.key] = item[obj.key].int
                case .string:
                    dict[obj.key] = item[obj.key].string
                default:
                    // TODO: Document is not handled
                    // TODO: Array is not handled
                    break
                }

            }

        }

        return dict
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
            
            guard let roleId = req.userInfo["Tori-Role"] as? Int else {
                Log.error("User role not passed")
                return
            }
            
            guard let userRole = Role(rawValue: roleId) else {
                Log.error("User role not found")
                return
            }

            for rule in self.acl {
                if (rule.index(forKey: userRole) != nil) {
                    if rule.values.first?.read == .all {

                        let allItems = try! self.collection.find()

                        let dict = self.bsonToDict(bson: allItems)

                        let response: [String: AnyObject] = [
                                           "status": "ok",
                                           "model": self.slug,
                                           "data": dict
                                           ]

                        Log.debug(response.description)

                        res.json(withJson: JSON(response))
                        return
                    }
                }
            }

            res.error(withMsg: "user has no permission")

        }

        // GET single item with Id
        router.get("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.parameters["id"] else {
                res.error(withMsg: "missing id")
                return
            }

            self.delegate?.preHook?(forType: .get)
            self.delegate?.postHook?(forType: .get)
        }

        // POST creates a new item
        router.post("/api/\(slug)") {
            req, res, next in
            
            self.delegate?.preHook?(forType: .set)
            self.delegate?.postHook?(forType: .set)
        }

        // PUT updates an existing item
        router.put("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.parameters["id"] else {
                res.error(withMsg: "missing id")
                return
            }
            
            self.delegate?.preHook?(forType: .update)
            self.delegate?.postHook?(forType: .update)

        }

        // DELETE removes an existing item
        router.delete("/api/\(slug)/:id") {
            req, res, next in
            guard let itemId = req.parameters["id"] else {
                res.error(withMsg: "missing id")
                return
            }
            
            self.delegate?.preHook?(forType: .delete)
            self.delegate?.postHook?(forType: .delete)
        }
    }
}
