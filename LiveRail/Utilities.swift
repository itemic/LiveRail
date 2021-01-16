//
//  Utilities.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/16/21.
//

import Foundation

// https://www.vadimbulavin.com/handling-out-of-bounds-exception/
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
