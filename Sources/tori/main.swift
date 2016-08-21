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
#if os(Linux)
import Glibc
#endif

// kitura
import KituraSys
import KituraNet
import Kitura

// mongodb orm
import MongoKitten

// logger
import LoggerAPI
import HeliumLogger
HeliumLogger.use()

// router setup
let router = Router()

// database setup
let db = setupDb()


// Extra routes
var customRoutes: [Route] = []
customRoutes.append(DummyRoute())

// setup tori with routes
let tori = Tori(withRoutes: customRoutes)

// get config
let (_, _, _, toriPort, _, _, _) = getConfiguration()

// start server
Kitura.addHTTPServer(onPort: toriPort, with: router)
Kitura.run()

Log.debug("Tori is running at port \(toriPort)")
