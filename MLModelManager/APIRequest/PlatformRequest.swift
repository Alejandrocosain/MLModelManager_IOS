//
//  PlatformRequest.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation


struct PlatformUserRequest: APIRequest {
    typealias Response = [Platform]
    var path: String {"/platform/userplatforms"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct PlatformAdminRequest: APIRequest {
    typealias Response = [Platform]
    var path: String {"/platform/all"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}



struct SendPlatformRequest:APIRequest {
    typealias Response = Platform
    var path: String {"/platform/register"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    var name: String
    var ip: String
    var description: String
    var dictPlatform: [String:String] {
        return ["name": name, "ip":ip, "description":description]
    }
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictPlatform)
        
    }
    
}
struct CreateCodeLangRequest: APIRequest {
    typealias Response = CodeLang
    var path: String {"/codelang/register"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    var name: String
    var type: String
    var dictLang: [String:String] {
        return ["name":name, "type":type]
    }
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictLang)
        
    }


}


struct AssignLanguageToPlatformRequest: APIRequest {
    typealias Response = Void
    var platformId: UUID
    var codelangId: UUID
    var path: String {"/platform/register/codelang/\(platformId.uuidString)/\(codelangId.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RemoveLanguageToPlatformRequest: APIRequest {
    typealias Response = Void
    var platformId: UUID
    var codelangId: UUID
    var path: String {"/platform/remove/codelang/\(platformId.uuidString)/\(codelangId.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct GetSpecificPlatformRequest: APIRequest {
    typealias Response = Platform
    var platformID: UUID
    var path: String {"/platform/\(platformID.uuidString)"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct GetAllCodeLangRequest: APIRequest {
    typealias Response = [CodeLang]
    var path: String {"/codelang/getall"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct SendAssignPlatAdminRequest: APIRequest {
    typealias Response = Void
    var platformID: UUID
    var userID: UUID
    var path: String {"/platform/register/platadmin/\(userID.uuidString)/\(platformID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}

struct SendRemovePlatAdminRequest: APIRequest {
    typealias Response = Void
    var platformID: UUID
    var userID: UUID
    var path: String {"/platform/remove/platadmin/\(userID.uuidString)/\(platformID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct GetPlatformModelsRequest: APIRequest {
    typealias Response = [ModelML]
    var platformID: UUID
    var path: String {"/platform/\(platformID.uuidString)/allmodels"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    
    
}


