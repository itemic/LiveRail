//
//  HSRTrainViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

final class HSRTrainViewModel: ObservableObject {
    
    @Published var train: RailDailyTimetable?
    
        func fetchTrainDetails(for train: String, client: NetworkManager) {
            HSRService.getTrainDetails(for: train, client: client) {[weak self] train in
                DispatchQueue.main.async {
                    self?.train = train[0] // single element array
                    print("fetched train details")
                }
            }
        }
}
