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

import CouchDB
import SwiftyJSON

// Retrieves tori configuration form config.json file
func getConfiguration () -> (ConnectionProperties, String) {
    
    guard let configDir = String.fromCString(getenv("CONFIG_DIR")) else {
        print("Please set your CONFIG_DIR env var (export CONFIG_DIR=/path/)")
        exit(1)
    }
    
    guard let configData = NSData(contentsOfFile: configDir + "./config.json") else {
        print("Please check your config.json file exists at path "+configDir + "./config.json")
        exit(1)    
    }
    
    let configJson = JSON(data: configData)
    
    return (
        ConnectionProperties(hostName: "", port: Int16(27017), secured: false),
        "dbName"
    )

}