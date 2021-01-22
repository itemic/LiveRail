//
//  HSRViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

final class HSRDataStore: ObservableObject {
    @Published var stations: [Station] = [] // all stations
    @Published var lastUpdateDate: Date
    
    @Published var stationTimetableDict: [Station: [StationTimetable]] = [:]
    @Published var fareSchedule: [String: [String: FareSchedule]] = [:]
    
    // TODO: Save station list to local storage
    init(client: NetworkManager) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss (+z)"
        lastUpdateDate = Date(timeIntervalSince1970: 0)
        HSRService.getHSRStations(client: client) {[weak self] stations in
            DispatchQueue.main.async {
                self?.stations = stations
//                LocationManager.shared.stations = stations
                for station in stations {
                    self!.fareSchedule[station.StationID] = [:]
                    self!.stationTimetableDict[station] = []
                    self?.fetchTimetable(for: station, client: client)
                }
//                LocationManager.shared.closestStation()
            }
        }
        HSRService.getFares(client: client) { [weak self] fares in
            DispatchQueue.main.async {
                for fare in fares {
                    
                    self!.fareSchedule[fare.OriginStationID]![fare.DestinationStationID] = fare
                }
            }
            
        }
        
    }
    
    func stationName(from id: String) -> String? {
        return stations.first {
            $0.StationID == id
        }?.StationName.En
    }
    
    func station(from id: String) -> Station? {
        return stations.first {
            $0.StationID == id
        }
    }
    
    func fetchTimetable(for station: Station, client: NetworkManager) {
        let calendar = Calendar.current
        // compare dates
        let now = Date()
        
        if (stationTimetableDict[station]!.isEmpty) {
            HSRService.getTimetable(for: station, client: client) {[weak self] timetables in
                DispatchQueue.main.async {
                    print("Fetching...")
                    self?.stationTimetableDict[station] = timetables
                    self?.lastUpdateDate = now
                }
            }
        } else if (calendar.numberOfDaysBetween(lastUpdateDate, and: now) > 0){
           // invalidated because new day
            HSRService.getTimetable(for: station, client: client) {[weak self] timetables in
                DispatchQueue.main.async {
                    print("Fetching...")
                    self?.stationTimetableDict[station] = timetables
                    self?.lastUpdateDate = now
                }
                
            }
        } else {
            // already loaded, don't re-fetch
            // unless forced (TODO)
        }
        
        
    }

    
    
}
