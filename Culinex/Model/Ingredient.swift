import Foundation
import SwiftData
import SwiftUI

@Model
class Ingredient: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var image: Data?
    @Relationship(inverse: \RecipeStep.ingredients) var recipeSteps: [RecipeStep] = []
    
    init(id: UUID = UUID(), name: String, image: Data? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}

