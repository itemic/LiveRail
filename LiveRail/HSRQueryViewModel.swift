
import Foundation

final class HSRQueryViewModel: ObservableObject {
    @Published var queryResultTimetable: [RailODDailyTimetable] = []
    @Published var availability: [RailODDailyTimetable: AvailableSeat] = [:]
    @Published var timetable: [RailDailyTimetable] = []

    
    func getTimetable(for train: String) -> RailDailyTimetable? {
        timetable.first {
            $0.DailyTrainInfo.TrainNo == train
        }
    }
    
    func fetchQueryTimetables(from origin: String, to destination: String, client: NetworkManager) {
        
        HSRService.getTimetable(from: origin, to: destination, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                self?.queryResultTimetable = timetables
//                self?.fetchAvai
                for item in timetables {
                    self?.fetchAvailability(from: origin, on: item, client: client)
                    self?.fetchTrainDetails(for: item.DailyTrainInfo.TrainNo, client: client)
                }

            }
        }
    }
    
    func fetchTrainDetails(for train: String, client: NetworkManager) {
        HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
            DispatchQueue.main.async {
                self?.timetable.append(train[0])
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
    
}

