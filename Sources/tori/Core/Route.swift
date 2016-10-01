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

// plugins
import ToriAllowRemoteOrigin
import ToriHasParameter
import ResponseTime

import SwiftyJSON

import MongoKitten


// logger
import HeliumLogger
import LoggerAPI

// document types
enum RouteDocumentType {
    case permission
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
enum RouteTypes {
    case getAll
    case get
    case set
    case update
    case delete
}

protocol Jsonable {
    var json: JSON { get }
}

protocol Bsonable {
    var bson: JSON { get }
}

class Route: PermissionSafe {

    var slug = ""
    
    var dbModelName: String {
        return self.slug.capitalized
    }
    
    var collection: MongoKitten.Collection {
        return db[self.dbModelName]
    }
    
    // stores the permission for this route
    var permission: Permission
    
    // manages the schema connected to the route
    var schema: [String: RouteDocumentType]

    // contains the keys that need to be skipped on response
    var blacklistedKeys: [String]
    
    // hooks
    var preHook: ((_ type: RouteTypes) -> Bool)?
    var postHook: ((_ type: RouteTypes, _ response: JSON) -> JSON)?

    init(withPath slug: String, withSchema schema:[String: RouteDocumentType], withPermission permission: Permission, andBlacklistingKeys blacklistedKeys: [String] = []) {
        assert(slug.characters.count > 0, "Schema must contain at least a key")
        self.slug = slug
        assert(schema.count > 0, "Schema must contain at least a key")
        self.schema = schema
        self.permission = permission
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
                
                case .permission:
                    dict[obj.key] = item[obj.key].string as AnyObject?
                case .date:
                    dict[obj.key] = item[obj.key].string as AnyObject?
                case .boolean:
                    dict[obj.key] = item[obj.key].bool as AnyObject?
                case .double:
                    dict[obj.key] = item[obj.key].double as AnyObject?
                case .int:
                    dict[obj.key] = item[obj.key].int as AnyObject?
                case .objectId:
                    dict[obj.key] = item[obj.key].objectIdValue!.hexString as AnyObject?
                case .string:
                    dict[obj.key] = item[obj.key].string as AnyObject?
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
        router.all("/api/"+slug+"/*", middleware: [
            AllowRemoteOrigin(),
            BodyParser(),
            CheckRequestIsValidJson(),
            TokenAuthentication(),
            ResponseTime()
        ])
        
        // set validator for params based calls
        router.all("/api/"+slug+"/:id", middleware: [HasParameter(params: ["id"])])
        
        // GET single item with Id
        router.get("/api/"+slug+"/:id") { req, res, _ in
            //Log.debug(req.body)
        }

        // GET all items
        router.get("/api/"+slug) { req, res, _ in
            
            // pre hook handler
            if self.preHook?(.getAll) == false {
                return
            }
            
            // retrieve user
            guard let user = req.getUser() else {
                res.error(withMsg: "missing user")
                return
            }
            
            // retrieve permission for current user
            let permission = user.checkPermission(forRoute: self)
            
            // check permission
            switch permission {
            case .none, .w:
                res.error(withMsg: "user non allowed")
                return
            default: break
            }
            
            let allItems = try! self.collection.find()
            // TODO: need to be improved
            let dict = self.bsonToDict(bson: allItems)
            
            var response: JSON = [
                "status": "ok",
                "model": self.slug,
                "data": dict
            ]

            // post hook handler
            if let hookedResponse = self.postHook?(.getAll, response) {
                response = hookedResponse
            }
            
            Log.debug(response.description)
            
            res.json(withJson: response)
            
        }
        
        // FIXME: Check issue with other routes, fail to compile, need new version of swift3 ?
        
        // POST creates a new item
        router.post("/api/"+slug) { req, res, _ in
            //Log.debug(req)
        }

        // GET single item with Id
        router.get("/api/"+slug+"/:id") { req, res, _ in
            //Log.debug(req)
        }

        // PUT updates an existing item
        router.put("/api/"+slug+"/:id") { req, res, _ in
            //Log.debug(req)
        }

        // DELETE removes an existing item
        router.delete("/api/"+slug+"/:id") { req, res, _ in
            //Log.debug(req)
        }
    }
}
