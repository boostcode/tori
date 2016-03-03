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

import LoggerAPI

import SwiftyJSON

import Orca
import OrcaSQLite

// database errors
enum dbDriverError : ErrorType{
  case MissingDriver
  case NotSupportedYet
  case MongoConnectionError
}

// database setup
func setupDbDriver () throws -> Driver {
  let (dbDriver, dbHost, dbPath, dbPort, dbName) = getDbConfiguration()

  switch dbDriver {
    case "SQLite":
      return OrcaSQLite(path: dbPath+"/"+dbName)
    case "MongoDB":
      throw dbDriverError.NotSupportedYet
      /*let mongo = OrcaMongoDB()
      mongo.connect(host: dbHost, port: dbPort, database: dbName) { error in
        if error {
          throw dbDriverError.MongoConnectionError
        }
      }
      return mongo*/
    default:
      throw dbDriverError.MissingDriver
  }

}

// Retrieves tori db configuration form config.json file
func getDbConfiguration () -> (String, String, String, UInt16, String) {

  let errorPrefix = "Configuration / "

  guard let configDir = String.fromCString(getenv("TORI_CONFIG_DIR")) else {
    Log.error(errorPrefix+"Please set your CONFIG_DIR env var (e.g. export TORI_CONFIG_DIR=/var/tori)")
    exit(1)
  }
  guard let configData = NSData(contentsOfFile: configDir + "/config_db.json") else {
    Log.error(errorPrefix+"Please check your config.json file exists at path "+configDir + "/config_db.json")
    exit(1)
  }

  let configJson = JSON(data: configData)

  if let configString = configJson.rawString() {
    Log.verbose(configString)    
  }

  guard let dbDriver = configJson["dbDriver"].string else {
    Log.error(errorPrefix+"Missing db driver")
    exit(1)
  }
  guard let dbHostname = configJson["dbHost"].string else {
    Log.error(errorPrefix+"Missing ip address")
    exit(1)
  }
  guard let dbIpPort = configJson["dbPort"].number else{
    Log.error(errorPrefix+"Missing port address")
    exit(1)
  }
  guard let dbName = configJson["dbName"].string else {
    Log.error(errorPrefix+"Missing database name")
    exit(1)
  }
  guard let dbPath = configJson["dbPath"].string else {
    Log.error(errorPrefix+"Missing database path")
    exit(1)
  }

  return (
    dbDriver,
    dbHostname,
    dbPath,
    UInt16(dbIpPort.intValue),
    dbName
  )

}
