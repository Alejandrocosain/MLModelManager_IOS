//
//  DatabaseKelpel.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 27/02/24.
//

import Foundation

struct DatabaseKelpel: Codable,Hashable {
    let id: UUID
    let name: String
    let ip: String
    let description: String
    let dbAdmin: User?
    let tables: [TableKelpel]
    let creatorUser: User
}

struct TableKelpel: Codable, Hashable {
    
    let id: UUID
    let name: String
    let description: String
    
}
