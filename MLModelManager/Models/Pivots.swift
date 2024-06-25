//
//  ModelMLPlatformPivot.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 19/06/24.
//

import Foundation


struct ModelMLPlatformPivot: Codable, Hashable {
    let id: UUID
    let modelML: ModelMLPivot
    let platform: Platform
    let toValidate: Int
    let validated: Int
 
}

struct ModelMLDatabasePivot: Codable, Hashable {
    let id: UUID
    let modelML: ModelMLPivot
    let database: DatabaseKelpel
    let toValidate: Int
    let validated: Int
 
}


struct ModelMLPivot: Codable, Hashable {
    let id: UUID
    let name: String
}

struct ModelMLStandardPivotPublic: Codable, Hashable {
    let id: UUID
    let standard: Standards
    let modelML: ModelMLPivot
    let toValidate: Int
    let validated: Int
    
}
