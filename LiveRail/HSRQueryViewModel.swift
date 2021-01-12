
import Foundation

final class HSRQueryViewModel: ObservableObject {
    @Published var queryResultTimetable: [RailODDailyTimetable] = []
    @Published var availability: [RailODDailyTimetable:AvailableSeat] = [:]

    
    func fetchQueryTimetables(from origin: String, to destination: String, client: NetworkManager) {
        
        HSRService.getTimetable(from: origin, to: destination, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                print("Fetching...")
                self?.queryResultTimetable = timetables
                self?.availability = [:] // empty dict
                for item in timetables {
                    print("FETCH")
                    self?.fetchAvailability(from: origin, to: destination, on: item, client: client)
                    
                }

            }
        }
    }
    
    func fetchAvailability(from origin: String, to destination: String, on timetable: RailODDailyTimetable, client: NetworkManager) {
        
        HSRService.getAvailability(from: origin, to: destination, on: timetable.DailyTrainInfo.TrainNo, client: client) { [weak self] ava in
            DispatchQueue.main.async {
                print("...")
                self?.availability[timetable] = ava.AvailableSeats.first
            }
        }
        
    }
    
}

