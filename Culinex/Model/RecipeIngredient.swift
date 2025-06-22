//  RecipeIngredient.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredient: Identifiable {
    @Attribute(.unique) var id = UUID()
    var quantity: Double
    var unit: String
    
    // Relashionship, which step does this amount of recipe belongs to?
    // One to ...
    @Relationship(inverse: \RecipeStep.stepIngredients)
    var step: RecipeStep?
    
    var ingredient: Ingredient?
    
    init(quantity: Double, unit: String, ingredient: Ingredient, step:RecipeStep) {
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
        self.step = step
    }
}

/// Usage example:
//let step1 = RecipeStep(...)
//let flour = Ingredient(...)
//let flourUsage = RecipeIngredient(...)
//
//context.insert(step1)
