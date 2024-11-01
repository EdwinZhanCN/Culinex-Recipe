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
    
    @Relationship(deleteRule: .nullify)
    var skills: [Skill]
    
    var tools: [String]
    var durationValue: Double
    var durationUnit: UnitOfTime

    init(
        id: UUID = UUID(),
        ingredients: [Ingredient],
        description: String,
        skills: [Skill],
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

