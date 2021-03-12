//
//  HSRStore.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/4/21.
//

import Foundation

public final class HSRStore: ObservableObject {

    //TODO: Store stations locally; unlikely to change
    //TODO: Check RailDailyTimetable has additional services
    @Published var stations: [Station] = []
    @Published var lastUpdateDate: Date = Date(timeIntervalSince1970: 0) // initialize from zero
    @Published var dailyTimetable: [RailDailyTimetable] = []
    @Published var availableSeats: [Station: [AvailableSeat]] = [:]
    @Published var fareSchedule: [String: [String: FareSchedule]] = [:]
    @Published var initSuccess: Bool = true

    
    public static let shared = HSRStore(client: .init())
    
    init(client: NetworkManager) {
        
        self.localBundleData()
        self.reload(client: client)
    }
    
    func localBundleData() {
        // code to decode from bundle
        self.stations = Bundle.main.decode([Station].self, from: "stations.json")
        for station in stations {
            self.fareSchedule[station.StationID] = [:]
        }
        let fares = Bundle.main.decode([FareSchedule].self, from: "odfare.json")
        for fare in fares {
            self.fareSchedule[fare.OriginStationID]![fare.DestinationStationID] = fare
        }
    }
    
    func reload(client: NetworkManager) {
        
        self.initSuccess = true
        
        HSRService.getRailDailyTimetable(client: client) { [weak self] dt in
            DispatchQueue.main.async {
                self?.dailyTimetable = dt
            }
        } failure: {
            print("rail daily")
            OperationQueue.main.addOperation {
                self.initSuccess = false
            }
            
        }
        
    
        
        HSRService.getHSRStations(client: client) {[weak self] stations in
            DispatchQueue.main.async {
                self?.stations = stations
                for station in stations {
                    self!.fetchAvailability(station: station, client: client)
                }
            }
        } failure: {
            print("stations")
            OperationQueue.main.addOperation {
                self.initSuccess = false
            }
        }
        
        // TODO Fix this 
        HSRService.getFares(client: client) { [weak self] fares in
            DispatchQueue.main.async {
                for fare in fares {
//                    print (fare)
                    self!.fareSchedule[fare.OriginStationID]![fare.DestinationStationID] = fare
                }
            }
            
        } failure: {
            print("fares")
            OperationQueue.main.addOperation {
                self.initSuccess = false
            }
        }
        
        // reset last update time (for now)
        // in future, use this to debounce
        lastUpdateDate = Date()
    }
    
    func fetchAllAvailability(client: NetworkManager) {
        for station in stations {
            fetchAvailability(station: station, client: client)
        }
    }
    
    func fetchAvailability(station: Station, client: NetworkManager) {
        HSRService.getAvailability(from: station.StationID, client: client) { [weak self] availability in
            DispatchQueue.main.async {
                self?.availableSeats[station] = availability.AvailableSeats
            }
        } failure: {
            // do someti
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
    
    func getStation(from stationID: String) -> Station {
        return stations.first(where: {
            $0.StationID == stationID
        })!
    }
    
    // the following functions should really be in the departures viewmodel
    
    func getArrivalTime(for train: RailDailyTimetable, at station: Station) -> String {
        return train.StopTimes.first(where: {
            $0.StationID == station.StationID
        })!.ArrivalTime
    }
    
    func getDepartureTime(for train: RailDailyTimetable, at station: Station) -> String {
        return train.StopTimes.first(where: {
            $0.StationID == station.StationID
        })!.DepartureTime
    }
    
    // train has not departed
    func getTrainWillDepartAfterNow(for train: RailDailyTimetable, at station: Station) -> Bool {
        return Date.compare(to: getDepartureTime(for: train, at: station))
    }
    
    // train has not arrived
    func getTrainWillArriveAfterNow(for train: RailDailyTimetable, at station: Station) -> Bool {
        return Date.compare(to: getArrivalTime(for: train, at: station))
    }
    
    func getTrainIsAtStation(for train: RailDailyTimetable, at station: Station) -> Bool {
        return getTrainWillDepartAfterNow(for: train, at: station) && !getTrainWillArriveAfterNow(for: train, at: station)
    }
    
    func isEndingTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return train.DailyTrainInfo.EndingStationID == station.StationID
    }
    
    func isStartingTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return train.DailyTrainInfo.StartingStationID == station.StationID
    }
    
    func isTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return isEndingTerminus(for: train, at: station) || isStartingTerminus(for: train, at: station)
    }
    
    
    // following functions are for query timetables
    func getDeparturesWith(from origin: Station, to destination: Station) -> [RailDailyTimetable] {
        return dailyTimetable.filter({ dt in
            dt.StopTimes.contains(where: {
                $0.StationID == origin.StationID
            }) &&
            dt.StopTimes.contains(where: {
                $0.StationID == destination.StationID
            }) &&
            dt.StopTimes.first(where: {
                $0.StationID == origin.StationID
            })!.DepartureTime < dt.StopTimes.first(where: {
                $0.StationID == destination.StationID
            })!.DepartureTime
        })
        .sorted {
            $0.StopTimes.first(where: { (s1: StopTime) -> Bool in
                s1.StationID == origin.StationID
            })! < $1.StopTimes.first(where: { (s1: StopTime) -> Bool in
                s1.StationID == origin.StationID
            })!
        }
    }
    
    func getStopTime(for station: Station, on train: RailDailyTimetable) -> StopTime{
        return train.StopTimes.first(where: {
            $0.StationID == station.StationID
        })!
    }
    
    // for availability; TODO need to poll frequently
    func getAvailability(for train: String, from station: Station) -> AvailableSeat? {

        let avail = availableSeats[station]?.first(where: {
            $0.TrainNo == train
        })
        return avail
    }
    
    func getAvailability(from station: Station) -> [AvailableSeat] {
        return availableSeats[station] ?? []
    }
    
}
