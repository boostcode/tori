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

import SwiftyJSON

func setupTori() {
    
    // routes
    routerAuth()

    let routeUser = Route(
        withPath: "user",
        withACL: [
                     [.Admin: adminPermission],
                     [.Guest: ACL(read: .None, write: .None)]
        ])
    routeUser.enableRoutes()


    // root routing
    router.get("/") {
        request, response, next in
        response.json(withJson: JSON([ "msg": "Hello, tori!"]))
        next()
    }


}