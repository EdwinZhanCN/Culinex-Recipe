import Foundation
import SwiftData

@Model
class Skill: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var ARFileName: String?
    // No @Relationship macro here, we defined in RecipeStep
    var recipeSteps: [RecipeStep] = []
    
    var displayName: String {
        return self.name
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String = "General",
        ARFileName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.ARFileName = ARFileName
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

/// Usage example:
//let newSkill = Skill(...)
//let newStep = RecipeStep(...)
//
//newSkill.recipeSteps.append(newStep)
//modelContext.insert(newSkill)
