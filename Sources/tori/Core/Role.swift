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

struct ACL {

    enum AccessType {
        case None // cannot access any data
        case Mine // can access only personal data
        case All // can access everything (except blacklisted)
    }

    let read: AccessType
    let write: AccessType

}

// admin user has rights over all the fields, even third party ones
let adminPermission = ACL(read: .All, write: .All)
