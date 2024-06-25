//
//  LoginRequest.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 22/02/24.
//

import Foundation

struct NewEmployee: Codable {
    var username: String
    var password: String
    var role: String
    var fullName: String
    var employeeId: Int
    var job: String

}

struct SignupRequest: APIRequest {
    typealias Response = NewSession
    
    var path: String {"/user/usersignup"}
    var username: String
    var password: String
    var role: String
    var fullName: String
    var employeeId: Int
    var job: String
    
    var newEmployee: NewEmployee {
        return NewEmployee(username: username, password: password, role: role, fullName: fullName, employeeId: employeeId, job: job)
    }
 
    
    var postData: Data?{
        let encoder = JSONEncoder()
        return try! encoder.encode(newEmployee)
    }
    
    var method: String {"POST"}
    
}

struct LoginRequest: APIRequest {
    typealias Response = NewSession
    
    var path: String {"/user/login"}
    var username: String
    var password: String
    
    var loginString: String {"\(username):\(password)"}
    
    var loginData: Data {Data(loginString.utf8)}
    
    var base64LoginString: String {loginData.base64EncodedString()}
    
    var auth: String? {"Basic \(base64LoginString)"}
    
    var method: String {"POST"}
    
    
}

struct AllUsersRequest: APIRequest {
    typealias Response = [User]
    
    var path: String {"/user/getall"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

    
}

struct RolesUsersRequest: APIRequest {
    typealias Response = [User]
    
    var roles: String
    var path: String {"/user/getroles/\(roles)"}
    var auth: String? {"Bearer \(MLModelNetwork.actualToken!)"}

    
}



