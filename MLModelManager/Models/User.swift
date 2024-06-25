//
//  User.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 22/02/24.
//

import Foundation

struct User: Codable, Hashable {
    
    let username: String
    let id: UUID
    let role: String
    let job: String
    let fullName: String
    
}

struct NewSession: Codable {
    
    let token: String
    let user: User
}

