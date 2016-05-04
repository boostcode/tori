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

// kitura
import KituraSys
import KituraNet
import Kitura

// mongodb orm
import MongoKitten

// logger
import LoggerAPI
import HeliumLogger

#if os(Linux)
    import Glibc
#endif

// router setup
let router = Router()

// setup logger
Log.logger = HeliumLogger()

// database setup
let (dbHost, dbPort, dbName, adminName, adminPassword) = getDbConfiguration()
let dbServer = try! Server(at: dbHost, port: dbPort)
let db = dbServer[dbName]

// db setup
//setupDb()

// routes
router.all("/admin", middleware: StaticFileServer(path:"./public/admin", options:[]))

routerUser()

// routing
router.get("/") {
  request, response, next in
  response.status(HttpStatusCode.OK).send("Hello, tori!")
  next()
}

// setup server
let server = HttpServer.listen(port: 8090, delegate: router)
Server.run()
