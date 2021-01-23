//
//  DailyTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation



struct RailODDailyTimetable: Codable, Identifiable, Hashable {
    static func == (lhs: RailODDailyTimetable, rhs: RailODDailyTimetable) -> Bool {
        return lhs.DailyTrainInfo.TrainNo == rhs.DailyTrainInfo.TrainNo
    }
    
    
    
    var id: String {
        DailyTrainInfo.TrainNo
    }
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    
    var OriginStopTime: StopTime
    var DestinationStopTime: StopTime
    
}

struct RailDailyTimetable: Codable, Hashable {
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    var StopTimes: [StopTime]
    
    func stopsAt(_ station: Station) -> Bool {
        return StopTimes.contains {
            $0.StationID == station.StationID
        }
    }
    
    // For OD transformation
    var OriginStopTime: StopTime?
    var DestinationStopTime: StopTime?
    
    func isStarting(stop: StopTime) -> Bool {
        return stop.StationID == DailyTrainInfo.StartingStationID
    }
    
    func isEnding(stop: StopTime) -> Bool {
        return stop.StationID == DailyTrainInfo.EndingStationID
    }
    
    func isTrainAtStation(stop: StopTime) -> Bool {
        return !stop.willArriveAfterNow && stop.willDepartAfterNow
    }
    
    func trainIsAtStation() -> Bool {
        return StopTimes.contains {
            isTrainAtStation(stop: $0)
        }
     }
    
    func currentTrainAtStation() -> StopTime? {
        return StopTimes.first {
            isTrainAtStation(stop: $0)
        }
    }
    
    func nextStation() -> StopTime? {
        return StopTimes.first {
            $0.willArriveAfterNow
        }
    }
    
    func prevStation() -> StopTime? {
        return StopTimes.last {
            !$0.willDepartAfterNow
        }
    }
    
    func getTrainProgress() -> (StopTime, Double)? {
        
        guard let prev = prevStation(), let next = nextStation() else { return nil }

        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let nextArrivalTime = dateFormatter.date(from: next.ArrivalTime) else { return nil }
        guard let prevDepartureTime = dateFormatter.date(from: prev.DepartureTime) else { return nil }
        
        let minutesBetweenStations = nextArrivalTime.time - prevDepartureTime.time
        let midpoint = minutesBetweenStations / 2
        let minutesOfCurrentPosition = now.time - prevDepartureTime.time
        
        let proportion: Double = 2 *  (Double(minutesOfCurrentPosition) / Double(minutesBetweenStations))
        print("mbs \(minutesBetweenStations) mocp \(minutesOfCurrentPosition) = p \(proportion)")
        
        if (trainIsAtStation()) {
            return (currentTrainAtStation()!, 0)
        }
        else if (minutesOfCurrentPosition < midpoint) {
            // prev station
            return (prev, proportion)
        } else {
            // next station
            return (next, -(proportion/2))
        }
    }
    
}

struct DailyTrainInfo: Codable, Hashable {
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: NameType
    var EndingStationID: String
    var EndingStationName: NameType

    
    var direction: TrainDirection {
        TrainDirection(fromRawValue: Direction)
    }
}

struct StopTime: Codable, Hashable {
    static func < (lhs: StopTime, rhs: StopTime) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let lhsD = dateFormatter.date(from: lhs.DepartureTime)!
        let rhsD = dateFormatter.date(from: rhs.DepartureTime)!
        
        return lhsD < rhsD
    }
    var StopSequence: Int
    var StationID: String
    var StationName: NameType
    var ArrivalTime: String
    var DepartureTime: String
    
    var willDepartAfterNow: Bool {
        return Date.compareNowTo(otherTime: DepartureTime)
    }
    
    var willArriveAfterNow: Bool {
        return Date.compareNowTo(otherTime: ArrivalTime)
    }
    
    
}
