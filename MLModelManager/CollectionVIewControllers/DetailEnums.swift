//
//  DatabaseDetailItem.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 04/03/24.
//

import Foundation

enum DatabaseDetailItem: Hashable {
    
    case description([String])
    case table(TableKelpel)
    case model(ModelML)
    case dbAdmin(User)
    
    var description: [String]? {
        if case .description(let string) = self {
            return string
        } else {
            return nil
        }
    }
    var table: TableKelpel? {
        if case .table(let tableKelpel) = self {
            return tableKelpel
        } else {
            return nil
        }
    }
    var model: ModelML? {
        if case .model(let modelML) = self {
            return modelML
        } else {
            return nil
        }
    }
    var dbAdmin: User? {
        if case .dbAdmin(let user) = self {
            return user
        } else {
            return nil
        }
    
    }
}


enum PlatformDetailItem: Hashable {
    
    case description([String])
    case model(ModelML)
    case platAdmin(User)
    case progLanguages(CodeLang)

    
    var description: [String]? {
        if case .description(let string) = self {
            return string
        } else {
            return nil
        }
    }
    var model: ModelML? {
        if case .model(let modelML) = self {
            return modelML
        } else {
            return nil
        }
    }
    var platAdmin: User? {
        if case .platAdmin(let user) = self {
            return user
        } else {
            return nil
        }
    
    }
    var progLanguages: CodeLang? {
        if case .progLanguages(let codeLang) = self {
            return codeLang
        } else {
            return nil
        }
    }
}


enum MLModelDetailItem: Hashable {
    
    case description([String])
    case owner(User)
    case database(DatabaseKelpel)
    case platform(Platform)
    case standard(Standards)

    
    var description: [String]? {
        if case .description(let string) = self {
            return string
        } else {
            return nil
        }
    }

    var owner: User? {
        if case .owner(let user) = self {
            return user
        } else {
            return nil
        }
    
    }
    var database: DatabaseKelpel? {
        if case .database(let database) = self {
            return database
        } else {
            return nil
        }
    }
    
    var platform: Platform? {
        if case .platform(let platform) = self {
            return platform
        } else {
            return nil
        }
    }
    
    var standard: Standards? {
        if case .standard(let standard) = self {
            return standard
        } else {
            return nil
        }
    }
    
}
