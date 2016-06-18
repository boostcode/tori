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

struct User {
  // id
  var id: String = ""
  // username
  var username: String = ""
  // email
  var email: String = ""
  // password
  var password: String = ""//= "".sha256() // TODO: remove, I know is useless, but acts as reminder
  // access tokens
  var tokenAccess: AccessToken?
  // role
  //var role: Role = Role()
  // push tokens
  var pushTokens: [PushToken]?

  /*init(bson: BSON.Document) {
    self.mapFromDb(bson)
  }*/

  /*mutating func mapFromDb(item: BSON.Document) {
    if let id = item["id"] {
      self.id = id.stringValue!
    }
    if let username = item["username"] {
      self.username = username.stringValue!
    }
  }*/

}
