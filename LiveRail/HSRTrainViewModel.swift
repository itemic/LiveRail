//
//  HSRTrainViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

final class HSRTrainViewModel: ObservableObject, Equatable {
    static func == (lhs: HSRTrainViewModel, rhs: HSRTrainViewModel) -> Bool {
        lhs.train == rhs.train
    }
    
    
    @Published var train: RailDailyTimetable? = nil
    
    func fetchTrainDetails(for train: String, client: NetworkManager) {
        HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
            DispatchQueue.main.async {
                self?.train = train[0] // single element array
                print("fetched train details")
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
        return !stop.willArriveAfterNow && stop.willDepartAfterNow
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
            $0.willArriveAfterNow
        }
    }
    
    var prevStation: StopTime?{
        guard let train = train else {return nil}
        return train.StopTimes.last {
            !$0.willDepartAfterNow
        }
    }
    
    var allDepartedStations: [StopTime] {
        guard let train = train else {return []}
        return train.StopTimes.filter {
            !$0.willDepartAfterNow
        }
    }
    
    var getTrainProgress: (StopTime, Double)? {
        guard let prev = prevStation, let next = nextStation else {return nil}
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let nextArrivalTime = dateFormatter.date(from: next.ArrivalTime) else { return nil }
        guard let prevDepartureTime = dateFormatter.date(from: prev.DepartureTime) else { return nil }
        
        let minutesBetweenStations = nextArrivalTime.time - prevDepartureTime.time
        let minutesOfCurrentPosition = now.time - prevDepartureTime.time
        
        let proportion: Double = (Double(minutesOfCurrentPosition) / Double(minutesBetweenStations))
        
        
        if let trainAtStation = currentTrainAtStation {
            return (trainAtStation, 0)
        }

        
        return (prev, proportion)
    }
    
}
