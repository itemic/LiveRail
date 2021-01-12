//
//  HSRViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

final class HSRViewModel: ObservableObject {
    @Published var stations: [Station] = [] // all stations
    @Published var stationTimetables: [StationTimetable] = [] // current station
    @Published var train: RailDailyTimetable? // current train

    // TODO: Save station list to local storage
    init(client: NetworkManager) {
        HSRService.getHSRStations(client: client) {[weak self] stations in
            DispatchQueue.main.async {
                self?.stations = stations
            }
        }
    }
    
    func fetchTimetable(for station: Station, client: NetworkManager) {
        
        HSRService.getTimetable(for: station, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                print("Fetching...")
                self?.stationTimetables = timetables
            }
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
