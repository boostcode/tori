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

// permissions levels
enum Permission {
    case None
    case ReadOnly
    case WriteOnly
    case ReadWrite
    case Admin
}

// First time setup database structure
func setupDb() {

    // TODO: if not existing create db

    // TODO: if not existing create collection

    let roleCollection = db["Roles"]
    
    // Roles guest
    if try! roleCollection.count(matching: "name" == "guest") == 0 {
        
        let guestRole: Document = [
                "name": "guest",
                "permissions": [
                    "*" : ~Permission.ReadOnly.hashValue
                ]
        ]
        
        try! roleCollection.insert(guestRole)
        Log.debug("Setup / Added role guest")
    }

    // Roles admin
    if try! roleCollection.count(matching: "name" == "admin") == 0 {
        
        let adminRole: Document = [
            "name": "admin",
            "permissions": [
                "*" : ~Permission.Admin.hashValue
            ]
        ]
        
        try! roleCollection.insert(adminRole)
        Log.debug("Setup / Added role admin")
    }
    
    // User admin
    let userCollection = db["Users"]

    if try! userCollection.count(matching: "username" == adminName) == 0 {

        let role = try! roleCollection.findOne(matching: "name" == "admin")

        let adminUser: Document = [
            "username": .string(adminName),
            "password": .string("\(adminPassword.md5())"),
            "role": ~role!
        ]
    
        try! userCollection.insert(adminUser)
        Log.debug("Setup / Added default admin user: \(adminName)")
    }
    
}
