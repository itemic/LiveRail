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
    
    static func getHSRStations(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: (([Station]) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$top=30&$format=JSON"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    static func getRailDailyTimetable(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today"
        var request = client.authenticateRequest(url: url)
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
    
    static func getTrainDetails(for train: String, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, client: NetworkManager, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {

        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today/TrainNo/\(train)?$format=JSON"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
        
    }
    
   
    
 

    static func getAvailability(from origin: String, policy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, client: NetworkManager, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/AvailableSeatStatusList/\(origin)"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = policy
        
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    static func getAllAvailability(client: NetworkManager, policy: URLRequest.CachePolicy = .reloadIgnoringCacheData, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/AvailableSeatStatusList"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = policy
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getFares(client: NetworkManager, policy: URLRequest.CachePolicy = .useProtocolCachePolicy, completion: (([FareSchedule]) -> Void)? = nil, failure: FailAction) {
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/ODFare"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = policy
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    
    
    static func runRequest<T: Codable>(_ request: URLRequest, on client: NetworkManager, completion: ((T) -> Void)? = nil, failure: FailAction) {
        client.executeRequest(request: request) { result in
            switch result {
            case .success(let data):
//                print("Run request success")
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode(T.self, from: data)
//                    print(res)
//                    print("HERE")
                    completion?(res)
                } catch {
                    print(error)
//                    print("CATCH")
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
