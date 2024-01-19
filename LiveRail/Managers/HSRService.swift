//
//  StationService.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import Foundation

public struct HSRService {
    typealias FailAction = (() -> Void)?
    static let df = SharedDateFormatter.shared
    
    static func getAuthToken(client: NetworkManager, completion: ((Token) -> Void)? = nil, failure: FailAction) {
        guard let url = URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token") else {
            preconditionFailure("URL is broken")
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        
        let postData: Data = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&grant_type=client_credentials".data(using: .utf8)!
        
        request.httpBody = postData
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getHSRStations(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, token: String, completion: (([Station]) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/Station?$top=30&$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    static func getRailDailyTimetable(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, token: String, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {
//        if (token == "") {
//            token = client.acquireToken()
//        }
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/Today?%24format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
//    static func getTimetable(for station: Station, client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: (([StationTimetable]) -> Void)? = nil, failure: FailAction) {
//        
//        let now = df.taiwanTZString(from: Date())
//        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Station/\(station.StationID)/\(now)?$format=JSON"
//        var request = client.authenticateRequest(url: url)
//        request.cachePolicy = policy
//        
//        runRequest(request, on: client, completion: completion, failure: failure)
//    }
    
    static func getTrainDetails(for train: String, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, client: NetworkManager, token: String, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {
      
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/Today/TrainNo/\(train)?$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
        
    }
    
   
    
 

    static func getAvailability(from origin: String, policy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, client: NetworkManager, token: String, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/AvailableSeatStatusList/\(origin)"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    static func getAllAvailability(client: NetworkManager, policy: URLRequest.CachePolicy = .reloadIgnoringCacheData, token: String, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/AvailableSeatStatus/Train/Leg/Today?$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getFares(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, token: String, completion: (([FareSchedule]) -> Void)? = nil, failure: FailAction) {
       
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/ODFare?$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getNews(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, token: String, completion: (([NewsPost]) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/News?$top=30&$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getAlertInfo(client: NetworkManager, policy: URLRequest.CachePolicy = .reloadIgnoringCacheData, token: String, completion: (([AlertInfo]) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/AlertInfo?$top=30&$format=JSON"
        var request = client.authenticateRequest(url: url, token: token)
        request.cachePolicy = policy
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    
    static func runRequest<T: Codable>(_ request: URLRequest, on client: NetworkManager, completion: ((T) -> Void)? = nil, failure: FailAction) {
        client.executeRequest(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode(T.self, from: data)
//                    print("HERE")
                    completion?(res)
                } catch {
                    print(data.base64EncodedString())
                    print(error)
                    print("CATCH \(T.self)")
                    failure?()
                }
            case .failure(let error):
                print(error)
//                print("FAILURE -- most likely network")
                failure?()
            }
        }
    }
    
}
