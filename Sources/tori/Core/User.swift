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

struct User: UserProtocol {
    
    var bson = Document()
    
    var name: String {
        return bson["name"].string
    }
    var group: Groups {
        return Groups(rawValue: bson["group"].int)!
    }
    var permission: Permission {
        return Permission(fromBSON: bson["permission"])
    }
    
}

private typealias CheckPermission = User
extension CheckPermission {
    func checkPermission(forObject object: Document) -> Permission.UGO.Rights {
        return self ~= Permission(fromBSON: object["permission"])
    }

    func checkPermission(forRoute route: Route) -> Permission.UGO.Rights {
        return self ~= route.permission
    }
    
}
