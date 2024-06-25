//
//  ModelML.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation

struct ModelML: Codable, Hashable {
    let id: UUID
    let name: String
    let owner: User
    let description: String
    let latestVersionValidated: Int
    let status: String
    let databases: [DatabaseKelpel]
    let platforms: [Platform]
    let standards: [Standards]
    let modelCreator: User
}

struct Standards: Codable, Hashable {
    let id: UUID
    let name: String
    let type: String
    let description: String
    
}

struct ModelMLStandardPivot: Codable, Hashable {
    let id: UUID
    let validated: Int
    let standard: StandardID
    let toValidate: Int
}


struct StandardID: Codable, Hashable {
    let id: UUID
}
