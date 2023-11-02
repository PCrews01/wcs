//
//  Item.swift
//  wchs
//
//  Created by Paul Crews on 11/2/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
