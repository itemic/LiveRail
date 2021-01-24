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
    
    
    @Published var train: [RailDailyTimetable] = []
    
//    init(with train: String) {
//        fetchTrainDetails(for: train, client: .init())
//    }
    
        func fetchTrainDetails(for train: String, client: NetworkManager) {
            HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
                DispatchQueue.main.async {
                    self?.train = train // single element array
                    print("fetched train details")
                }
            }
        }
}
