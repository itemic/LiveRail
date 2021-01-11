//
//  HSRViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

final class HSRViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var stationTimetables: [StationTimetable] = []

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
                self?.stationTimetables = timetables
            }
        }
    }
    
    
}
