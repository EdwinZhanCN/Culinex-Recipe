import Foundation
import SwiftData
import SwiftUI

@Model
class Ingredient: Identifiable {
    @Attribute(.unique) var name: String
    var image: Data?
    
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.ingredient)
    var recipeIngredients: [RecipeIngredient]?
        
    var displayName: String {
        return self.name
    }
    
    static let placeholder = Ingredient(name: "Loading...")
    
    init(name: String, image: Data? = nil) {
        self.name = name
        self.image = image
    }
}
