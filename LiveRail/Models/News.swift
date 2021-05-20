//
//  News.swift
//  LiveRail
//
//  Created by Terran Kroft on 5/20/21.
//

import Foundation

struct NewsPost: Codable, Identifiable {
    var id: String {
        NewsID
    }
    
    var NewsID: String
    var Title: String
    var Description: String //html content idk if this breaks
    var NewsUrl: String
    var NewsCategory: String
    var StartTime: String
    
}
