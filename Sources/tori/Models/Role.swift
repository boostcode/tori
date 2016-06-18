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

// permissions levels
enum Permission {
    case None
    case ReadOnly
    case WriteOnly
    case ReadWrite
    case Admin
}

struct Role {
    var name: String = ""
    var permission = [String: Permission]()
    
    init(document: Document) {
        self.mapFromDocument(document: document)
    }
    
    mutating func mapFromDocument(document: Document) {
        if let name = document["name"].stringValue {
            self.name = name
        }
        
        if let permission = document["permission"].storedValue as? [String: Permission] {
            self.permission = permission
        }
    }
    
    func toDocument() -> Document {
        return [
            "name": .string(self.name),
            //"permission": Document(array: self.permission)
        ]
    }
}
