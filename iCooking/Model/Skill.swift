import Foundation
import SwiftData

@Model
class Skill: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var ARObject: Data?
    
    @Relationship(inverse: \RecipeStep.skills) var recipeSteps: [RecipeStep] = []
    
    init(id: UUID = UUID(), name: String, category: String = "General", ARObject: Data? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.ARObject = ARObject
    }
    
    // Different icon for each category
    var icon: String {
        switch category {
            case "General": return "frying.pan"
            case "Cutting": return "frying.pan"
            case "Cooking": return "flame"
            case "Baking": return "oven"
            default: return "frying.pan"
        }
    }
}
