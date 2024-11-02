import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    @Relationship(deleteRule: .cascade)
    var steps: [RecipeStep]
    @Transient
    var recipeViews: Int = 0
    
    init(
        id: UUID = UUID(),
        name: String,
        steps: [RecipeStep]
    ) {
        self.id = id
        self.name = name
        self.steps = steps
    }
    
    func removeStep(_ step: RecipeStep) {
        steps.removeAll(where: { $0.id == step.id })
    }
}
