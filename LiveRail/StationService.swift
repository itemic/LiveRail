//
//  StationService.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import Foundation

public struct HSRService {
    
    static func getHSRStations(client: NetworkManager, completion: (([Station]) -> Void)? = nil) {
        runGetHSRStationsRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$top=30&$format=JSON"), on: client, completion: completion)
    }
    
    static func getTimetable(for station: Station, client: NetworkManager, completion: (([StationTimetable]) -> Void)? = nil) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        
        runGetTimetableRequest(client.authenticateRequest(url: "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Station/\(station.StationID)/\(now)?$format=JSON"), on: client, completion: completion)
    }
    
    
    static func runGetHSRStationsRequest(_ request: URLRequest, on client: NetworkManager, completion: (([Station]) -> Void)? = nil) {
        client.executeRequest(request: request) { result in
            switch result {
            case .success(let data):
                print("Initial success")
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode([Station].self, from: data)
                    print(res)
                    completion?(res)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func runGetTimetableRequest(_ request: URLRequest, on client: NetworkManager, completion: (([StationTimetable]) -> Void)? = nil) {
        client.executeRequest(request: request) { result in
            switch result {
            case .success(let data):
                print("Initial success")
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode([StationTimetable].self, from: data)
                    print(res)
                    completion?(res)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
