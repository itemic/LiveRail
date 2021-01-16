
import Foundation

final class HSRQueryViewModel: ObservableObject {
    @Published var queryResultTimetable: [RailODDailyTimetable] = []
    @Published var availability: [RailODDailyTimetable: AvailableSeat] = [:]

    
    func fetchQueryTimetables(from origin: String, to destination: String, client: NetworkManager) {
        
        HSRService.getTimetable(from: origin, to: destination, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                print("Fetching...")
                self?.queryResultTimetable = timetables
//                self?.fetchAvai
                for item in timetables {
                    self?.fetchAvailability(from: origin, on: item, client: client)

                }

            }
        }
    }
    
    func fetchAvailability(from origin: String, on timetable: RailODDailyTimetable, client: NetworkManager) {
        HSRService.getAvailability(from: origin, client: client) { [weak self] availability in
            DispatchQueue.main.async {
                
                let seat = availability.AvailableSeats.first {
                    $0.TrainNo == timetable.DailyTrainInfo.TrainNo
                }
                
                self?.availability[timetable] = seat
            }
            
            
        }
    }
    
//    func fetchAvailability(from origin: String, to destination: String, on timetable: RailODDailyTimetable, client: NetworkManager) {
//
//        HSRService.getAvailability(from: origin, to: destination, on: timetable.DailyTrainInfo.TrainNo, client: client) { [weak self] ava in
//            DispatchQueue.main.async {
//                print("Fetching availability")
//                self?.availabilityX[timetable] = ava.AvailableSeats.first
//            }
//        }
//
//    }
    
}

