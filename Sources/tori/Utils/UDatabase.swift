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
import LoggerAPI
import SwiftyJSON
import MongoKitten

// First time setup database structure
func setupDb() {

    // TODO: if not existing create db

  // TODO: if not existing create collection

  let userCollection = db["Users"]

  if try! userCollection.count(matching: "username" == adminName) == 0 {
    let adminUser: Document = [
      "username": Value(stringLiteral: adminName),
      "password": Value(stringLiteral: adminPassword)
    ]
    try! userCollection.insert(adminUser)
    //userCollection.addOrUpdate(adminUser)
    Log.debug("Setup / Added default admin user")
  }
}
