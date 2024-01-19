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
    @Published var token = ""
    
    init(client: NetworkManager) {
        HSRService.getAuthToken(client: client) {[weak self] tk in
            DispatchQueue.main.async {
                self?.token = tk.access_token
                HSRService.getNews(client: client, token: tk.access_token) {[weak self] newsPost in
                    DispatchQueue.main.async {
                        self?.newsPosts = newsPost
                    }
                } failure: {
                    
                }
            }
        } failure: {
            print("news st ore error")
            
        }
        
       
    }
}


public final class AlertStore: ObservableObject {
    @Published var alertData: [AlertInfo] = []
    @Published var token = ""
    public static let shared = AlertStore(client: .init())
    
    init(client: NetworkManager) {
       
        
        
        HSRService.getAuthToken(client: client) {[weak self] tk in
            DispatchQueue.main.async {
                self?.token = tk.access_token
                HSRService.getAlertInfo(client: client, token: tk.access_token) {[weak self] alert in
                    DispatchQueue.main.async {
                        self?.alertData = alert
                    }
                } failure: {
                    
                }
            }
        } failure: {
            print("news st ore error")
            
        }
    }

}
