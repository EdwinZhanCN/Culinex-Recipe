import Foundation
import SwiftData

@Model
class Ingredient: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var image: String?
    @Relationship(inverse: \RecipeStep.ingredients) var recipeSteps: [RecipeStep] = []
    
    init(id: UUID = UUID(), name: String, image: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}

