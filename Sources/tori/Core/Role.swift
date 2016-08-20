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

struct AccessRights {

    enum AccessType {
        case none // cannot access any data
        case mine // can access only personal data
        case all // can access everything (except blacklisted)
    }

    let read: AccessType
    let write: AccessType

}

typealias ACLRuleElement = [Role: AccessRights]

struct ACLRule {
    var rules = [ACLRuleElement]()

    // easy way to generate acl rules
    mutating func addRule(forRole role: Role, withACL acl: AccessRights) {
        rules.append([role: acl])
    }
}


// admin user has rights over all the fields, even third party ones
let adminPermission = AccessRights(read: .all, write: .all)

