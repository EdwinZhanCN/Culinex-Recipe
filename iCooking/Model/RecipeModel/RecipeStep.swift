//
//  Step.swift
//  iCooking
//
//  Created by 詹子昊 on 2/12/24.
//

import Foundation
import SwiftData

@Model
class RecipeStep: Identifiable {
    var id: UUID = UUID()
    
    var ingredients: [Ingredient]
    var descrip: String
    var skills: [String]
    var tools: [String]
    
    // 用于表示 StepTime 的属性
    var durationValue: Double
    var durationUnit: UnitOfTime

    init(
        id: UUID = UUID(),
        ingredients: [Ingredient],
        description: String,
        skills: [String],
        tools: [String],
        duration: StepTime
    ) {
        self.id = id
        self.ingredients = ingredients
        self.descrip = description
        self.skills = skills
        self.tools = tools
        self.durationValue = duration.value
        self.durationUnit = duration.unit
    }

    // 计算属性，用于返回 StepTime 结构体
    var duration: StepTime {
        get {
            StepTime(value: durationValue, unit: durationUnit)
        }
        set {
            durationValue = newValue.value
            durationUnit = newValue.unit
        }
    }
}

