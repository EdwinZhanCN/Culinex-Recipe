//
//  StepTime.swift
//  iCooking
//
//  Created by 詹子昊 on 10/26/24.
//

import Foundation

struct StepTime {
    var value: Double
    var unit: UnitOfTime
}

enum UnitOfTime: String, Codable {
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
