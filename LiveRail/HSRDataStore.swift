//
//  HSRViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

final class HSRDataStore: ObservableObject {
    @Published var stations: [Station] = [] // all stations
//    @Published var stationTimetables: [StationTimetable] = [] // current station
    
    @Published var stationTimetableDict: [Station: [StationTimetable]] = [:]
    
    // TODO: Save station list to local storage
    init(client: NetworkManager) {
        HSRService.getHSRStations(client: client) {[weak self] stations in
            DispatchQueue.main.async {
                self?.stations = stations
                for station in stations {
                    self!.stationTimetableDict[station] = []
                    self?.fetchTimetable(for: station, client: client)
                }
            }
        }
        
        
    }
    
    func fetchTimetable(for station: Station, client: NetworkManager) {
        
        if (stationTimetableDict[station]!.isEmpty) {
            HSRService.getTimetable(for: station, client: client) {[weak self] timetables in
                DispatchQueue.main.async {
                    print("Fetching...")
                    self?.stationTimetableDict[station] = timetables
                }
            }
        } else {
            // already loaded, don't re-fetch
            // need to find way to invalidate cache
        }
        
        
    }

    
    
}
