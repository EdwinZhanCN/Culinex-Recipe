//
//  StepTime.swift
//  iCooking
//
//  Created by 詹子昊 on 10/26/24.
//

import Foundation

struct StepTime: Equatable {
    var value: Double
    var unit: UnitOfTime
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value && lhs.unit == rhs.unit
    }
}

enum UnitOfTime: String, Codable, Equatable {
    case hr
    case min
    case sec
    
    func toString(value: Double) -> String {
        switch self {
        case .hr:
            return value == 1 ? "hour" : "hours"
        case .min:
            return value == 1 ? "minute" : "minutes"
        case .sec:
            return value == 1 ? "second" : "seconds"
        }
    }
}
