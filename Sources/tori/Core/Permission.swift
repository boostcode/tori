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
import SwiftyJSON

protocol UserProtocol {
    var name: String { get }
    var group: Groups { get }
}

protocol PermissionSafe {
    var permission: Permission { get }
}

// roles
enum Groups: Int {
    case admin
    case user
}

struct Permission {
    
    struct UGO {
        
        enum Rights: Int {
            case none // nothing
            case r // only read
            case w // only write
            case rw // read & write
        }
        
        let user: Rights
        let group: Rights
        let other: Rights
    }
    
    let owner: String
    let group: Groups
    let ugo: UGO
    
    var bson: Document {
        return [
            "owner": ~owner,
            "group": ~group.rawValue,
            "ugo" : [
                "user": ~ugo.user.rawValue,
                "group": ~ugo.group.rawValue,
                "other": ~ugo.other.rawValue
            ]
        ]
    }
    
    init(withOwner owner: String = "", andGroup group: Groups, andUGO ugo: UGO) {
        self.owner = owner
        self.group = group
        self.ugo = ugo
    }
    
    init(fromBson bson: Value) {
        self.owner = bson["owner"].string
        self.group = Groups(rawValue: bson["owner"].int)!
        self.ugo = UGO(user: Permission.UGO.Rights(rawValue: bson["ugo"]["user"].int)!,
                       group: Permission.UGO.Rights(rawValue: bson["ugo"]["group"].int)!,
                       other: Permission.UGO.Rights(rawValue: bson["ugo"]["other"].int)!
        )
    }
    
    init(fromJson json: JSON) {
        self.owner = json["owner"].stringValue
        
        self.group = Groups(rawValue: json["group"].intValue)!
        
        let permissionUser = Permission.UGO.Rights(rawValue: json["ugo"]["user"].intValue)!
        let permissionGroup = Permission.UGO.Rights(rawValue: json["ugo"]["group"].intValue)!
        let permissionOther = Permission.UGO.Rights(rawValue: json["ugo"]["other"].intValue)!
        
        self.ugo = UGO(user: permissionUser, group: permissionGroup, other: permissionOther)
    }
}

func ~=(lhs: UserProtocol, rhs: Permission) -> Permission.UGO.Rights {
    
    // check for the groups matching
    if lhs.group == rhs.group {
        return rhs.ugo.group
    } else {
        
        // then (eventually) overrides for owner (if exists)
        if rhs.owner == "" {
            return rhs.ugo.other
        }
        
        if lhs.name == rhs.owner {
            return rhs.ugo.user
        } else {
            return Permission.UGO.Rights.none
        }
    }
}

let ugoAdmin = Permission.UGO(user: .rw, group: .rw, other: .r)
