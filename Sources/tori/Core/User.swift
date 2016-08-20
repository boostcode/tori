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

class User {

    var name: String
    var password: String
    var email: String
    var token: String
    var pushTokens: [Token]?
    
    var bson: Document {
        return [
            "username": ~name,
            "password": ~"\(password.md5)",
            "email": ~email,
            "tokens": ~tokens
        ]
    }
    
    init(withName name: String, andPassword password: String, andEmail email: String) {
        self.name = name
        self.password = password
        
        if email.isEmail == true {
            self.email = email
        } else {
            // TODO: manage invalid email
        }
        
    }
    
    init(fromBSON bson: BSON) {
        self.bson = bson
    }
    
    func checkPermission(forObject object: BSON) -> UGO.Permission {
        // TODO: check if owner
        return UGO.Permission.r
    }
}
