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
    private let appID =  APPLICATION_ID
    private let appKey = APPLICATION_KEY
    
    enum NetworkError: Error {
        case noData
    }

    func getServerTime() -> String {
        
        return SharedDateFormatter.shared.serverDate(from: Date())
    }
    
    func authenticateRequest(url: String) -> URLRequest {
        guard let url = URL(string: url) else {
            preconditionFailure("Invalid URL")
        }
        let xDate = getServerTime()
        let signDate = "x-date: \(xDate)"
        
        let key = SymmetricKey(data: Data(appKey.utf8))
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
        let base64HmacString = Data(hmac).base64EncodedString()
        
        let authorization = "hmac username=\"\(appID)\", algorithm=\"hmac-sha256\", headers=\"x-date\", signature=\"\(base64HmacString)\""
        
        var request = URLRequest(url: url)
        request.setValue(xDate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
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

