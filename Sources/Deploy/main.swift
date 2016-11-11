/**
 * Copyright IBM Corporation 2016
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
import HeliumLogger
import LoggerAPI
import TodoList

HeliumLogger.use()

let databaseServiceName = "TodoListCloudantDatabase"
let databaseName = "todolist"

let todos: TodoList

func getEnvInt(varName:String, defaultValue:Int) -> Int {
	var value : Int?
	
	if let varStringValue = ProcessInfo.processInfo.environment[varName] {
		value = Int(varStringValue)
	}
	return value ?? defaultValue
}

let host = ProcessInfo.processInfo.environment["CLOUDANT_HOST"] ?? "127.0.0.1"
let username = ProcessInfo.processInfo.environment["CLOUDANT_USERNAME"]
let password = ProcessInfo.processInfo.environment["CLOUDANT_PASSWORD"]
var dbPort = UInt16(getEnvInt(varName: "CLOUDANT_PORT", defaultValue: 5984))

todos = TodoList(database: databaseName, host: host, port: dbPort, username: username, password: password)


let controller = TodoListController(backend: todos)

var port = getEnvInt(varName: "PORT", defaultValue: 8090)

Kitura.addHTTPServer(onPort: port, with: controller.router)
Kitura.run()
    
    

