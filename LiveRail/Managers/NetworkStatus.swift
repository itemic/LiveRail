//
//  NetworkStatus.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/10/21.
//

import Foundation
import SwiftUI
import Network

class NetworkStatus: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    @Published var connected: Bool = false
    
    public static let shared = NetworkStatus()
    
    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                OperationQueue.main.addOperation {
                    self.connected = true
                }
            } else {
                OperationQueue.main.addOperation {
                    self.connected = false
                }
            }
        }
    }
}
