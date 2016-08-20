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

class CoreTori {
    
    init(withRoutes routes: [Route]) {
        
        // tori authentication routing
        routerAuth()
        
        // tori user routing
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
        
        
        // enable extra routes
        for route in routes {
            route.enableRoutes()
        }
        
        // static routing
        router.all("/", middleware: StaticFileServer())
    }
}
