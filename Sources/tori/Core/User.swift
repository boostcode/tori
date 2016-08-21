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
import MongoKitten

struct Token {
    var type: String
    var value: String
}

class User: UserProtocol {

    var name = ""
    var username = ""
    var password = ""
    var email = ""
    var group = Groups.user
    var token = ""
    var pushTokens: [Token]?
    var permission: Permission?
    
    var bson: Document {
        return [
            "username": ~name,
            "password": ~"\(password.md5)",
            "group": ~group.rawValue,
            "permission": ~permission!.bson,
            "email": ~email,
            "token": ~token,
            //"pushTokens": ~pushTokens // FIXME: manage tokens array
        ]
    }
    
    init(withName name: String, andUsername username: String, andPassword password: String, andEmail email: String, andGroup group: Groups = Groups.user) {
        
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.group = group
        
        self.permission = Permission(withOwner: name,
                                     andGroup: group,
                                     andUGO: Permission.UGO(user: .rw,
                                        group: .rw,
                                        other: .r
            )
        )
        
    }
    
    func map(fromUsername userName: String) {
        let userCollection = db["User"]
        guard let user = try! userCollection.findOne(matching: "username" == userName) else { return }

        map(fromBSON: user)
    }
    
    func map(fromBSON bson: Document) {
        
        name =  bson["name"].string
        username = bson["username"].string
        password = bson["password"].string
        email = bson["email"].string
        group = Groups(rawValue: bson["group"].int)!
        permission = Permission(fromBson: bson["permission"])
        
    }
    
    func save() {
        // TODO: db update
    }
    
}

private typealias CheckPermission = User
extension CheckPermission {
    func checkPermission(forObject object: Document) -> Permission.UGO.Rights {
        return self ~= Permission(fromBson: object["permission"])
    }

    func checkPermission(forRoute route: Route) -> Permission.UGO.Rights {
        return self ~= route.permission
    }
    
}
