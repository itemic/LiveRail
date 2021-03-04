//
//  HSRStore.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/4/21.
//

import Foundation

public final class HSRStore: ObservableObject {

    //TODO: Store stations locally; unlikely to change
    @Published var stations: [Station] = []
    @Published var lastUpdateDate: Date = Date(timeIntervalSince1970: 0) // initialize from zero
    @Published var dailyTimetable: [RailDailyTimetable] = []
    
    public static let shared = HSRStore(client: .init())
    
    init(client: NetworkManager) {
        // reset last update time (for now)
        lastUpdateDate = Date(timeIntervalSince1970: 0)
        HSRService.getRailDailyTimetable(client: client) { [weak self] dt in
            DispatchQueue.main.async {
                self?.dailyTimetable = dt
            }
        }
    }
    
    // get departures from provided station ID string
    func getDepartures(from stationID: String) -> [RailDailyTimetable] {
        
        return dailyTimetable.filter({ dt in
            dt.StopTimes.contains(where: {
                $0.StationID == stationID
            })
        })
        .sorted {
            $0.StopTimes.first(where: { (s1: StopTime) -> Bool in
                s1.StationID == stationID
            })! < $1.StopTimes.first(where: { (s1: StopTime) -> Bool in
                s1.StationID == stationID
            })!
        }
    }
}
