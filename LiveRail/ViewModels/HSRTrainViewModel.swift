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
    
    var infoBoxText: String {
        guard let train = train, let starting = startingStation, let ending = endingStation else {return "NO DATA"}
        
        let now = Date().time
        guard let origin = df.date(from: starting.DepartureTime) else {return "NO DATA"}
        guard let destination = df.date(from: ending.ArrivalTime) else {return "NO DATA"}
        
        if (now < origin.time) {
            let minutes = origin.time - now
            return "Departs \(starting.StationName.En) in \(minutes) min." // have yet to depart
        } else if (now > destination.time) {
            return "Arrived at \(ending.StationName.En)."
        } else {
            return "Enroute to \(ending.StationName.En)."
        }
    }
    
    var infoBoxSubText: String {
        guard let train = train, let starting = startingStation, let ending = endingStation else {return "NO DATA"}
        
        let now = Date().time
        guard let origin = df.date(from: starting.DepartureTime) else {return "NO DATA"}
        guard let destination = df.date(from: ending.ArrivalTime) else {return "NO DATA"}
        
        if (now < origin.time) {
            return ""
        } else if (now > destination.time) {
            return ""
        } else {
            if (trainIsAtAnyStation) {
                return "Currently at \(currentTrainAtStation!.StationName.En)"
            } else {
                guard let nextArrivalTime = df.date(from: nextStation!.ArrivalTime) else { return "ERROR" }
                let minutes = nextArrivalTime.time - now
                return "Next station: \(nextStation!.StationName.En) in \(minutes) min."
            }
        }
    }
    
    var infoBoxColor: Color {
        guard let train = train, let starting = startingStation, let ending = endingStation else {return .red}
        
        let now = Date().time
        guard let origin = df.date(from: starting.DepartureTime) else {return .red}
        guard let destination = df.date(from: ending.ArrivalTime) else {return .red}
        
        if (now < origin.time) {
            return .orange // have yet to depart
        } else if (now > destination.time) {
            return .secondary
        } else {
            return .green
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
