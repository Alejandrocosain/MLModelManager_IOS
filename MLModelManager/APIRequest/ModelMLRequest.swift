//
//  ModelMLRequest.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation

struct ModelMLUserRequest: APIRequest {
    typealias Response = [ModelML]
    var path: String {"/modelml/usermodels"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct ModelMLAdminRequest: APIRequest {
    typealias Response = [ModelML]
    var path: String {"/modelml/all"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct GetSpecificModelMLRequest: APIRequest {
    typealias Response = ModelML
    var mlModelID: UUID
    var path: String {"/modelml/\(mlModelID.uuidString)"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}


struct SendModelMLRequest:APIRequest {
    typealias Response = ModelML
    var path: String {"/modelml/register"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    var name: String
    var ownerID: UUID
    var description: String
    var status: String
    var dictModelML: [String:String] {
        return ["name": name, "ownerID":ownerID.uuidString, "description":description, "status" : status]
    }
    
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictModelML)
        
    }
    
}

struct AssignPlatformToModelMLRequest: APIRequest {
    typealias Response = Void
    var platformId: UUID
    var modelmlID: UUID
    var path: String {"/modelml/request/platform/\(modelmlID.uuidString)/\(platformId.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RemovePlatformToModelMLRequest: APIRequest {
    typealias Response = Void
    var platformId: UUID
    var modelmlID: UUID
    var path: String {"/modelml/remove/platform/\(modelmlID.uuidString)/\(platformId.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct AssignDatabaseoModelMLRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/request/database/\(modelmlID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RemoveDatabaseToModelMLRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/remove/database/\(modelmlID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct AssignStandardToModelMLRequest: APIRequest {
    typealias Response = Void
    var standardId: UUID
    var modelmlID: UUID
    var path: String {"/modelml/register/standard/\(modelmlID.uuidString)/\(standardId.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RemoveStandardOfModelMLRequest: APIRequest {
    typealias Response = Void
    var standardID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/remove/standard/\(modelmlID.uuidString)/\(standardID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct ValidatePetitionStandardOfModelMLRequest: APIRequest {
    typealias Response = Void
    var standardID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/validatepetition/standard/\(modelmlID.uuidString)/\(standardID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct UnvalidateStandardOfModelMLRequest: APIRequest {
    typealias Response = Void
    var standardID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/unvalidate/standard/\(modelmlID.uuidString)/\(standardID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct DeployModelMLRequest: APIRequest {
    typealias Response = Void
    var modelmlID: UUID
    var path: String {"/modelml/deploy/\(modelmlID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}

struct SendStandardRequest:APIRequest {
    typealias Response = Standards
    var path: String {"/standard/register"}
    var method: String {"POST"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
    var name: String
    var type: String
    var description: String
    var dictStandard: [String:String] {
        return ["name": name, "type":type, "description":description]
    }
    var postData: Data? {
        let encoder = JSONEncoder()
        return try! encoder.encode(dictStandard)
    }
    
}
struct GetAllStandardRequest: APIRequest {
    typealias Response = [Standards]
    var path: String {"/standard/all"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    }

struct GetModelStandardStatusRequest: APIRequest {
    typealias Response = [ModelMLStandardPivot]
    var path: String{"/modelml/standards/\(modelmlID.uuidString)"}
    var modelmlID: UUID
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct GetModelPlatformAssignationRequest: APIRequest {
    typealias Response = [ModelMLPlatformPivot]
    var path: String{"/platform/requests"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct GetModelPlatformAssignationRequestAdmin: APIRequest {
    typealias Response = [ModelMLPlatformPivot]
    var path: String{"/platform/requests/admin"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct GetModelDatabaseAssignationRequest: APIRequest {
    typealias Response = [ModelMLDatabasePivot]
    var path: String{"/database/requests"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

}

struct GetModelDatabaseAssignationRequestAdmin: APIRequest {
    typealias Response = [ModelMLDatabasePivot]
    var path: String{"/database/requests/admin"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}
struct AcceptDatabaseAssignationRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/accept/database/\(modelmlID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RejectDatabaseAssignationRequest: APIRequest {
    typealias Response = Void
    var databaseID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/reject/database/\(modelmlID.uuidString)/\(databaseID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
        
    }

struct AcceptPlatformAssignationRequest: APIRequest {
    typealias Response = Void
    var platformID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/accept/platform/\(modelmlID.uuidString)/\(platformID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
    
}
struct RejectPlatformAssignationRequest: APIRequest {
    typealias Response = Void
    var platformID: UUID
    var modelmlID: UUID
    var path: String {"/modelml/reject/platform/\(modelmlID.uuidString)/\(platformID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
        
    }

struct AcceptStandardPetitionRequest: APIRequest {
    typealias Response = Void
    var modelmlID: UUID
    var standardID: UUID
    var path: String {"/modelml/acceptpetition/standard/\(modelmlID.uuidString)/\(standardID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
        
    }
struct RejectStandardPetitionRequest: APIRequest {
    typealias Response = Void
    var modelmlID: UUID
    var standardID: UUID
    var path: String {"/modelml/rejectpetition/standard/\(modelmlID.uuidString)/\(standardID.uuidString)"}
    var method: String {"PUT"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
        
    }

struct GetAllPendingStandardsRequest: APIRequest {
    typealias Response = [ModelMLStandardPivotPublic]
    var path: String {"/modelml/standardrequest"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}
struct GetAllPendingStandardsRequestAdmin: APIRequest {
    typealias Response = [ModelMLStandardPivotPublic]
    var path: String {"/modelml/standardrequestadmin"}
    var method: String {"GET"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}
}
