//
//  HSRViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

final class HSRViewModel: ObservableObject {
    @Published var stations: [Station] = [] // all stations
//    @Published var stationTimetables: [StationTimetable] = [] // current station
    
    @Published var stationTimetableDict: [Station: [StationTimetable]] = [:]
    
    @Published var train: RailDailyTimetable? // current train

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
    
    func fetchTrainDetails(for train: String, client: NetworkManager) {
        HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
            DispatchQueue.main.async {
                self?.train = train[0] // single element array
            }
        }
    }
    
    
}
