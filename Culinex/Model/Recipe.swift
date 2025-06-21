import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    // Unique Identifer of this data model
    @Attribute(.unique) var name: String
    // Some required attributes
    var summary: String
    var creationDate: Date

    // Define Relationship, and deleteRule
    @Relationship(deleteRule: .cascade)
    var steps = [RecipeStep]()
    
    @Relationship(inverse: \FavoriteCollection.recipes)
    var favoriteItem: FavoriteCollection? // Optional relationship to a favorite item

    // Stored properties that you want to omit from writes to the persistent storage
    @Transient
    var recipeViews: Int = 0
    
    var Image: Data? // Optional image data for the recipe
    
    var calories: Int?
    
    init(
        name: String,
        summary: String,
        calories: Int? = nil,
    ) {
        self.name = name
        self.summary = summary
        self.creationDate = Date()
        self.calories = calories
    }
    
    var duration: Double {
        return steps.reduce(0) { total, step in
            total + step.duration.durationInSeconds
        }
    }
    
    func addNewStep(description: String, duration: StepTime) {
        let newStepOrder = self.steps.count
        let newStep = RecipeStep(description: description, duration: duration, order: newStepOrder)
        self.steps.append(newStep)
    }
}

/// Usage example:
//let newRecipeStep = RecipeStep(...) // Recipe? field wait for establish relationship
//let newRecipe = Recipe(...)// [RecipeStep]() field wait for establish relationship
//
//newRecipe.steps.append(newRecipeStep) // relationship established
//context.insert(newRecipe) // insert to context

