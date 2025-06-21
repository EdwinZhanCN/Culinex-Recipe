//
//  StepTime.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

struct StepTime: Equatable, Codable {
    var value: Double
    var unit: UnitOfTime
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value && lhs.unit == rhs.unit
    }
    init(value: Double, unit: UnitOfTime) {
        self.value = value
        self.unit = unit
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

extension StepTime {
    /// 将当前时长转换为以秒为单位的总时长
    var durationInSeconds: Double {
        switch self.unit {
        case .hr:
            return self.value * 3600 // 1 小时 = 3600 秒
        case .min:
            return self.value * 60   // 1 分钟 = 60 秒
        case .sec:
            return self.value
        }
    }
}
