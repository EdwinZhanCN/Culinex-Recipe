import Foundation
import SwiftData

@Model
class FavoriteItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    @Relationship(deleteRule: .nullify)
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), name: String, recipes: [Recipe]) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    
    func addRecipe(_ recipe: Recipe) {
        if !recipes.contains(where: { $0.id == recipe.id }) {
            recipes.append(recipe)
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        recipes.removeAll(where: { $0.id == recipe.id })
    }
}
