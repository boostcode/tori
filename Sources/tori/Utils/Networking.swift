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

import Kitura
import KituraSys
import KituraNet

import SwiftyJSON

// logger
import HeliumLogger
import LoggerAPI


// MARK: - Request
class CheckRequestIsValidJson: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        guard let body = request.body else {
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "Request is missing body"
                    ]))
                .end()
            return
        }

        guard case let .Json(json) = body else {
            try! response
                .status(.OK)
                .send(json: JSON([
                                     "status": "error",
                                     "message": "Request body is not in json format"
                    ]))
                .end()
            return
        }

        next()

    }
}

// MARK: - Response
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        response.setHeader("Access-Control-Allow-Origin", value: "*")
        response.setHeader("Content-Type", value: "application/json; charset=utf-8")
        next()

    }
}
