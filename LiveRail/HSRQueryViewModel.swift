
import Foundation

final class HSRQueryViewModel: ObservableObject {
    @Published var queryResultTimetable: [RailODDailyTimetable] = []
    
    func fetchQueryTimetables(from origin: Station, to destination: Station, client: NetworkManager) {
        
        HSRService.getTimetable(from: origin, to: destination, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                print("Fetching...")
                self?.queryResultTimetable = timetables
            }
        }
    }
    
    func fetchQueryTimetables(from origin: String, to destination: String, client: NetworkManager) {
        
        HSRService.getTimetable(from: origin, to: destination, client: client) {[weak self] timetables in
            DispatchQueue.main.async {
                print("Fetching...")
                self?.queryResultTimetable = timetables
            }
        }
    }
    
}

