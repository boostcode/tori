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
import MongoKitten

func setupDb() -> MongoKitten.Database {

    // database setup
    let (dbHost, dbPort, dbName, _, adminName, adminPassword, adminEmail) = getConfiguration()

    let dbServer = try! Server(at: dbHost,
                               port: dbPort,
                               automatically: true
    )
    let db = dbServer[dbName]

    // default user admin
    let userCollection = db["User"]

    if try! userCollection.count(matching: "username" == adminName) == 0 {
        
        var admin = User()
        
        // TODO: create user func?
        admin.bson["name"] = ~adminName
        admin.bson["username"] = ~adminName
        // TODO: add support for salt md5 from a key in JSON file
        admin.bson["password"] = ~adminPassword.md5
        admin.bson["email"] = ~adminEmail
        admin.bson["group"] = ~Groups.admin.rawValue
        
        print(admin)
        
        let _ = try! userCollection.insert(admin.bson)
        Log.debug("Setup / Added default admin user: \(adminName)")
    }
    
    return db
}
