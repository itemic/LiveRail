//
//  NewsStore.swift
//  LiveRail
//
//  Created by Terran Kroft on 5/20/21.
//

import Foundation

public final class NewsStore: ObservableObject {
    @Published var newsPosts: [NewsPost] = []
    public static let shared = NewsStore(client: .init())
    
    init(client: NetworkManager) {
        HSRService.getNews(client: client) {[weak self] newsPost in
            DispatchQueue.main.async {
                self?.newsPosts = newsPost
            }
        } failure: {
            
        }
       
    }
}


public final class AlertStore: ObservableObject {
    @Published var alertData: [AlertInfo] = []
    
    public static let shared = AlertStore(client: .init())
    init(client: NetworkManager) {
       
        HSRService.getAlertInfo(client: client) {[weak self] alert in
            DispatchQueue.main.async {
                self?.alertData = alert
            }
        } failure: {
            
        }
    }

}
