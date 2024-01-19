//
//  NetworkManager.swift
//
//  Created by Terran Kroft on 7/12/20.
//  Copyright © 2020 itemic. All rights reserved.
//

import Foundation
import CryptoKit

public final class NetworkManager {

    //Create a Constants.swift and set these values separately!
    private let appID =  CLIENT_ID
    private let appKey = CLIENT_SECRET
    private var token: String? = nil
    
    enum NetworkError: Error {
        case noData
    }

    func getServerTime() -> String {
        
        return SharedDateFormatter.shared.serverDate(from: Date())
    }
    
    func acquireToken() -> String {
        guard let url = URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token") else {
            preconditionFailure("URL is broken")
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params: [String: String] = [
            "grant_type": "client_credentials",
            "client_id": appID,
            "client_secret": appKey
        ]
        let encoder = JSONEncoder()
        
        let postData: Data = "client_id=\(appID)&client_secret=\(appKey)&grant_type=client_credentials".data(using: .utf8)!
        
        request.httpBody = postData
        var responseToken = ""
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil
            else {
            print("ERROR")
            return
        }
            let decoder = JSONDecoder()
            do {
                let jsonResponse = try? decoder.decode(Token.self, from: data)
                
                responseToken = jsonResponse!.access_token
                return
            } catch {
                print("not workin")
            }
            return
            
            
            
        }
            task.resume()
            return responseToken
        }
    

    
    func authenticateRequest(url: String, token: String) -> URLRequest {
        guard let url = URL(string: url) else {
            preconditionFailure("Invalid URL")
        }

        let xDate = getServerTime()
        let signDate = "x-date: \(xDate)"
        
        
//        let authorization = "hmac username=\"\(appID)\", algorithm=\"hmac-sha256\", headers=\"x-date\", signature=\"\(base64HmacString)\""
        let authorization = "Bearer \(token)"
        var request = URLRequest(url: url)
//        request.setValue(xDate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("br,gzip", forHTTPHeaderField: "Accept-Encoding")
        
        // Testing New Bit
        
        
        return request
        
    }
    
 
    
    func executeRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
}

