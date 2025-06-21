//
//  RecipeStep.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import Foundation
import SwiftData

@Model
class RecipeStep: Identifiable {
    var order: Int
    
    var descrip: String
    
    var tools: [Tool]?
    var duration: StepTime
    
    @Relationship(inverse: \Skill.recipeSteps) var skills = [Skill]()
    
    @Relationship(deleteRule: .cascade)
    var stepIngredients = [RecipeIngredient]()
    
    @Relationship(inverse: \Recipe.steps) var recipe: Recipe?

    init(
        description: String,
        duration: StepTime,
        order: Int
    ) {
        self.descrip = description
        self.duration = duration
        self.order = order
    }
}
