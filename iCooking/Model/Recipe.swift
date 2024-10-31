import Foundation
import SwiftData

@Model
class Recipe: Identifiable{
    @Attribute(.unique) var id: UUID
//Migration Hint: @Attribute(originalName: "customname") var name: String
    var name: String
    var ingredients:[Ingredient]
    @Relationship(deleteRule: .cascade)
    var steps:[RecipeStep]
    
    @Transient
    var recipeViews: Int = 0
    
    init(
        id: UUID = UUID(),
        name: String,
        ingredients: [Ingredient]? = [],
        steps: [RecipeStep]? = []
    ) {
        self.id = id
        self.name = name
        self.ingredients = ingredients!
        self.steps = steps!
    }
}
