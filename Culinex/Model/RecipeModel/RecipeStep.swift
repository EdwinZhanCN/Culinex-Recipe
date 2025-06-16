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
    @Attribute(.unique) var id: UUID

    var descrip: String
    var tools: [String]
    
    // duration
    var durationValue: Double
    var durationUnit: UnitOfTime
    
    @Relationship var skills: [Skill]
    @Relationship var ingredients: [Ingredient]



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

