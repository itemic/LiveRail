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
    
    static func getHSRStations(client: NetworkManager, completion: (([Station]) -> Void)? = nil, failure: FailAction) {
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$top=30&$format=JSON"), on: client, completion: completion, failure: failure)
    }
    
    
    static func getRailDailyTimetable(client: NetworkManager, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today"), on: client, completion: completion, failure: failure)
    }
    
    static func getTimetable(for station: Station, client: NetworkManager, completion: (([StationTimetable]) -> Void)? = nil, failure: FailAction) {
        
        let now = df.taiwanTZString(from: Date())
        
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Station/\(station.StationID)/\(now)?$format=JSON"), on: client, completion: completion, failure: failure)
    }
    
    static func getTrainDetails(for train: String, client: NetworkManager, completion: (([RailDailyTimetable]) -> Void)? = nil, failure: FailAction) {
        print("getting train details for \(train)")
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today/TrainNo/\(train)?$format=JSON"), on: client, completion: completion, failure: failure)
        
    }
    
    static func getTimetable(from origin: Station, to destination: Station, client: NetworkManager, completion: (([RailODDailyTimetable]) -> Void)? = nil, failure: FailAction) {
        
        let now = df.taiwanTZString(from: Date())
        
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/OD/\(origin.StationID)/to/\(destination.StationID)/\(now)?$format=JSON"), on: client, completion: completion, failure: failure)
        
    }
    
    static func getTimetable(from origin: String, to destination: String, client: NetworkManager, completion: (([RailODDailyTimetable]) -> Void)? = nil, failure: FailAction) {
        
        let now = df.taiwanTZString(from: Date())
        
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/OD/\(origin)/to/\(destination)/\(now)?$format=JSON"), on: client, completion: completion, failure: failure)
        
    }
    
 

    static func getAvailability(from origin: String, client: NetworkManager, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/AvailableSeatStatusList/\(origin)"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        print("REQUEST")
        
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    
    static func getAllAvailability(client: NetworkManager, completion: ((AvailabilityWrapper) -> Void)? = nil, failure: FailAction) {
        let url = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/AvailableSeatStatusList"
        var request = client.authenticateRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        print("requesting")
        runRequest(request, on: client, completion: completion, failure: failure)
    }
    
    static func getFares(client: NetworkManager, completion: (([FareSchedule]) -> Void)? = nil, failure: FailAction) {
        runRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/ODFare"), on: client, completion: completion, failure: failure)
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
