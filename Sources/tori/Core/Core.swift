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

import Kitura
import MD5
import SwiftyJSON

class CoreTori {
    init() {
        // routes
        routerAuth()
        
        var aclRules = ACLRule()
        aclRules.addRule(forRole: .Admin, withACL: adminPermission)
        aclRules.addRule(forRole: .Guest, withACL: AccessRights(read: .none, write: .none))
        
        _ = Route(withPath: "user",
                  withSchema: [
                    "username": .string,
                    "password": .string,
                    "email": .string,
                    "role": .role,
            ],
                  withACL: aclRules,
                  andBlacklistingKeys: ["password"]
            ).enableRoutes()
        
        // create hookable route
        
        let film = Route(withPath: "film",
                         withSchema: [
                            "name": .string,
                            "date": .date
                            
                            
            ], withACL: aclRules)
        film.delegate = self
        
        
        // static routing
        router.all("/", middleware: StaticFileServer())
    }
}

private typealias RouterHooks = CoreTori
extension RouterHooks: RouterDelegate {
    func preHook(forType type: RouteTypes) {
        print("test pre")
    }
    
    func postHook(forType type: RouteTypes) {
        print("test post")        
    }
}
