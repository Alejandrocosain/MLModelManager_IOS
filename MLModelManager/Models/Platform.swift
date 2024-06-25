//
//  Platform.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation

struct Platform: Codable, Hashable {
    let id: UUID
    let name: String
    let ip: String
    let description: String
    let platAdmin: User?
    let codeLangs: [CodeLang]
    let platformCreator: User
}

struct CodeLang: Codable, Hashable {
    let name: String
    let id: UUID
    let type: String
}
