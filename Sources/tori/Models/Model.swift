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
//import CryptoSwift

// logger
import HeliumLogger
import LoggerAPI

/*class Model {
  var collection: MongoDB.Collection!

  init(_ db: Database, name: String) {
    collection = Collection(database: db, name: name)
  }

  func query(query: BSON.Document) -> [BSON.Document] {
    return try! collection.find(query: query).all()
  }

  func getById(id: String) -> BSON.Document? {
    var query = BSON.Document()
    query["id"] = .String(id)
    return try! collection.find(query: query).nextDocument()
  }

  func all() -> [BSON.Document] {
    return try! collection.find().all()
  }

  func addOrUpdate(item: BSON.Document) {
    let id = item["id"]?.stringValue
    if id == nil {
      self.add(item)
    } else {
      self.update(item)
    }
  }

  private func add(item: BSON.Document) {
    Log.debug("insert")
    try! collection.insert(item)
  }

  private func update(item: BSON.Document) {
    var query = BSON.Document()
    query["id"] = item["id"]
    try! collection.update(query: query, newValue: item)
  }

  func removeById(id: String) {
    var query = BSON.Document()
    query["id"] = .String(id)
    try! collection.remove(query: query)
  }
}*/
