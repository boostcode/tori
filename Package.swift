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

import PackageDescription

let package = Package(
    name: "Tori",
    dependencies: [
      .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 0),
      .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 0),
      .Package(url: "https://github.com/IBM-Swift/Kitura-MustacheTemplateEngine.git", majorVersion: 1, minor: 0),
      .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", majorVersion: 1, minor: 0),
      .Package(url: "https://github.com/PlanTeam/MongoKitten.git", majorVersion: 1, minor: 7),
      .Package(url: "https://github.com/boostcode/Tori-AllowRemoteOrigin.git", majorVersion:0, minor: 2),
      .Package(url: "https://github.com/boostcode/Tori-HasParameter.git", majorVersion:0, minor: 2),
      //.Package(url: "https://github.com/boostcode/Tori-APNS.git", majorVersion: 0, minor: 2)
    ],
    exclude: ["Tests", "public", "Makefile", "Package-Builder"]
)
