//
//  HSRTrainViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation
import SwiftUI
import Combine
final class HSRTrainViewModel: ObservableObject, Equatable {
    let df = SharedDateFormatter.shared
    
    static func == (lhs: HSRTrainViewModel, rhs: HSRTrainViewModel) -> Bool {
        lhs.train == rhs.train
    }
    
    
    @Published var train: RailDailyTimetable? = nil

    
    func stopsAt(_ station: Station) -> Bool {
        guard let train = train else {return false}
        return train.StopTimes.contains {
            $0.StationID == station.StationID
        }
    }
    
    var startingStation: StopTime? {
        guard let train = train else {return nil}
        return train.StopTimes.first(where: {
            $0.StationID == train.DailyTrainInfo.StartingStationID
        })
    }
    
    var endingStation: StopTime? {
        guard let train = train else {return nil}
        return train.StopTimes.first(where: {
            $0.StationID == train.DailyTrainInfo.EndingStationID
        })
    }
    
    func isStarting(_ stop: StopTime) -> Bool {
        guard let train = train else {return false}
        return stop.StationID == train.DailyTrainInfo.StartingStationID
    }
    
    func isEnding(_ stop: StopTime) -> Bool {
        guard let train = train else {return false}
        return stop.StationID == train.DailyTrainInfo.EndingStationID
    }
    
    func isTrainAtStation(_ stop: StopTime) -> Bool {
        return !Date.compare(to: stop.ArrivalTime) && Date.compare(to: stop.DepartureTime)
    }
    
    var trainIsAtAnyStation: Bool {
        guard let train = train else {return false}
        return train.StopTimes.contains {
            isTrainAtStation($0)
        }
    }
    
    var currentTrainAtStation: StopTime? {
        guard let train = train else {return nil}
        return train.StopTimes.first {
            isTrainAtStation($0)
        }
    }
    
    var trainStatus: TrainServiceState {
        guard let _ = train else {return .unknown}
        guard let starting = startingStation, let ending = endingStation else {return .unknown}
        let now = Date().time
        guard let origin = df.date(from: starting.DepartureTime) else {return .unknown}
        guard let destination = df.date(from: ending.ArrivalTime) else {return .unknown}
        
        if (now < origin.time) {
            return .predeparture
        } else if (now > destination.time) {
            return .ended
        } else if (trainIsAtAnyStation) {
            return .station
        } else {
            return .enroute
        }
    }
    
    var timeUntilNextArri: Int {
        guard let _ = train else {return 0}

        guard let nextStation = nextStation else {return 0}
        guard let nextArrivalTime = df.date(from: nextStation.ArrivalTime) else {return 0}
        let now = Date().time
        let minutes = nextArrivalTime.time - now
        return minutes
    }
    
    var timeUntilTrainAtStationDeparts: Int {
        guard let _ = train else {return 0}

        guard let currentStation = currentTrainAtStation else {return -1}
        guard let departureTime = df.date(from: currentStation.DepartureTime) else {return -1}
        let now = Date().time
        let minutes = departureTime.time - now
        return minutes
    }
    
    var timeUntilNextDept: Int {
        guard let _ = train else {return 0}

        guard let nextStation = nextStation else {return 0}
        guard let nextDepartureTime = df.date(from: nextStation.DepartureTime) else {return 0}
        let now = Date().time
        let minutes = nextDepartureTime.time - now
        return minutes
    }
    
    var bannerTime: Int {
        guard let _ = train else {return 0}

        switch(trainStatus) {
        case .predeparture: return timeUntilNextDept
        case .enroute: return timeUntilNextArri
        case .station: return timeUntilTrainAtStationDeparts
        default: return 0
        }
    }
    
    var infoBoxText: String {
        guard let _ = train else {return "Error"}

        guard let starting = startingStation else {return "Error"}
        switch(trainStatus) {
        case .predeparture: return starting.StationName.En
        case .enroute: return nextStation?.StationName.En ?? ""
        case .station: return currentTrainAtStation?.StationName.En ?? ""
        case .ended: return "Train service ended"
        case .unknown: return "Error"
        }
    }
    
    var infoBoxDescription: String {
        guard let _ = train else {return "Error"}

        switch(trainStatus) {
        case .predeparture: return "Departing"
        case .enroute: return "Arriving at"
        case .station: return "Departing"
        case .ended: return ""
        case .unknown: return ""
        }
    }
    
    
    var infoBoxColor: Color {

        guard let train = train else {return .red}
        switch(trainStatus) {
        case .predeparture: return .hsrColor
        case .enroute: return train.DailyTrainInfo.direction.color
        case .station: return train.DailyTrainInfo.direction.color
        case .ended: return .secondary
        case .unknown: return .red
        }
        
    }
    
    var nextStation: StopTime? {
        guard let train = train else {return nil}
        return train.StopTimes.first {
            Date.compare(to: $0.ArrivalTime)
        }
    }
    
    var prevStation: StopTime?{
        guard let train = train else {return nil}
        return train.StopTimes.last {
            !Date.compare(to: $0.DepartureTime)
        }
    }
    
    var allDepartedStations: [StopTime] {
        guard let train = train else {return []}
        return train.StopTimes.filter {
            !Date.compare(to: $0.DepartureTime)
        }
    }
    
    var getTrainProgress: (StopTime, Double)? {
        
        guard let prev = prevStation, let next = nextStation else {return nil}
        let now = Date()
        
        guard let nextArrivalTime = df.date(from: next.ArrivalTime) else { return nil }
        guard let prevDepartureTime = df.date(from: prev.DepartureTime) else { return nil }
        
        let minutesBetweenStations = nextArrivalTime.time - prevDepartureTime.time
        let minutesOfCurrentPosition = now.time - prevDepartureTime.time
        
        let proportion: Double = (Double(minutesOfCurrentPosition) / Double(minutesBetweenStations))
        
        
        if let trainAtStation = currentTrainAtStation {
            return (trainAtStation, 0)
        }

        
        return (prev, proportion)
    }
    
    
    
    
}
