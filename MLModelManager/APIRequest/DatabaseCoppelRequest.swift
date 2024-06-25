//
//  DatabaseKelpelRequest.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation


struct DatabaseUserRequest: APIRequest {
    typealias Response = [DatabaseKelpel]
    var path: String {"/database/userdatabase"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct DatabaseAdminRequest: APIRequest {
    typealias Response = [DatabaseKelpel]
    var path: String {"/database/alldatabases"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct SendDatabaseRequest:APIRequest {
    typealias Response = DatabaseKelpel
    var path: String {"/database/register"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    var name: String
    var ip: String
    var description: String
    var dictDatabase: [String:String] {
        return ["name": name, "ip":ip, "description":description]
    }
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictDatabase)
        
    }
    
}

struct SendTableRequest: APIRequest {
    typealias Response = TableKelpel
    var databaseID: UUID
    var path: String {"/database/\(databaseID.uuidString)/registertable"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    var name: String
    var description: String
    var dictDatabase: [String:String] {
        return ["name": name, "description":description]
    }
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictDatabase)
        
    }
    
}

struct GetSpecificDatabaseRequest: APIRequest {
    typealias Response = DatabaseKelpel
    var databaseID: UUID
    var path: String {"/database/\(databaseID.uuidString)"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    
    
}

struct SendAssignDBAdminRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var userID: UUID
    var path: String {"/database/register/dba/\(userID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}

struct SendRemoveDBAdminRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var userID: UUID
    var path: String {"/database/remove/dba/\(userID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}


struct GetDatabaseModelsRequest: APIRequest {
    typealias Response = [ModelML]
    var databaseID: UUID
    var path: String {"/database/\(databaseID.uuidString)/allmodels"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    
    
}
