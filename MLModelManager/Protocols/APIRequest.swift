//
//  APIRequest.swift
//  MLModelManager
//
//  Created by Alejandro Cosain on 22/02/24.
//

import Foundation

enum APIError: Error {
    case itemsNotFound
    case requestFailed
}
protocol APIRequest {
    
    associatedtype Response
    
    var path: String {get}
    var queryItems: [URLQueryItem]? {get}
    var request: URLRequest {get}
    var method: String {get}
    var postData: Data? {get}
    var path1: String? {get}
    var path2: String? {get}
    var auth: String? {get}
    
}

extension APIRequest {

    var host: String {"127.0.0.1"}
    var port: Int {8080}
    var method: String {"GET"}
    
    
}

extension APIRequest {
    
    var queryItems: [URLQueryItem]? {nil}
    var postData: Data? {nil}
    var path1: String? {nil}
    var path2: String? {nil}
    var auth: String? {nil}
    
}

extension APIRequest {
    
    var request: URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = port
        components.path = path
        if let path1 = path1 {
            components.path = components.path + "/\(path1)"
        }
        if let path2 = path2  {
            components.path = components.path + "/\(path2)"
        }
        components.queryItems = queryItems
        print(components.path)
        print(components.url)
        var request = URLRequest(url: components.url!)
        
        if let auth = auth {
            request.setValue(auth, forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = method
        
        if let data = postData {
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
        print(components.url!)
        print(auth)
        return request
        
    }
    
}
extension APIRequest where Response: Decodable {
    func send() async throws -> Response {
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.itemsNotFound
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Response.self, from: data)
        
        return decoded
        
    }
    
}


extension APIRequest {
    func send() async throws -> Void {
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestFailed
        }
        
        
    }
}
