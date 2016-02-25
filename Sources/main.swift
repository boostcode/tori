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
 
// kitura
import KituraRouter
import KituraNet
import KituraSys

// logger
import HeliumLogger
import LoggerAPI

import Foundation

// setup Kitura router
let router = Router()

// setup logger
Log.logger = HeliumLogger()

router.get("/") {
request, response, next in

    response.status(HttpStatusCode.OK).send("Hello, tori!")

    next()
}

// setup server
let server = HttpServer.listen(8090, delegate: router)

// run the server
Server.run()