//
//  Item.swift
//  iCooking
//
//  Created by 詹子昊 on 2/8/24.
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
