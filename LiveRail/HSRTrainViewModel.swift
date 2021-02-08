//
//  HSRTrainViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

final class HSRTrainViewModel: ObservableObject, Equatable {
    let df = SharedDateFormatter.shared
    
    static func == (lhs: HSRTrainViewModel, rhs: HSRTrainViewModel) -> Bool {
        lhs.train == rhs.train
    }
    
    
    @Published var train: RailDailyTimetable? = nil
    
    func fetchTrainDetails(for train: String, client: NetworkManager) {
        HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
            DispatchQueue.main.async {
                self?.train = train[0] // single element array
            }
        }
    }
    
    func stopsAt(_ station: Station) -> Bool {
        guard let train = train else {return false}
        return train.StopTimes.contains {
            $0.StationID == station.StationID
        }
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
