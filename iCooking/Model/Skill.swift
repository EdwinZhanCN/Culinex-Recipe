import Foundation
import SwiftData

@Model
class Skill: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    
    @Relationship(inverse: \RecipeStep.skills) var recipeSteps: [RecipeStep] = []
    
    init(id: UUID = UUID(), name: String, category: String = "General") {
        self.id = id
        self.name = name
        self.category = category
    }
    
    // Different icon for each category
    var icon: String {
        switch category {
            case "General": return "frying.pan"
            case "Cutting": return "frying.pan"
            case "Cooking": return "frying.pan"
            case "Baking": return "frying.pan"
            default: return "frying.pan"
        }
    }
}
