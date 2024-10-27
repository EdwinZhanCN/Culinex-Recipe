import Foundation

class Recipe: Identifiable{
    var id:UUID = UUID()
    var name:String = ""
    var ingredients:[Ingredient] = []
    var steps:[RecipeStep] = []
    
    init(
        name: String,
        ingredients: [Ingredient],
        steps: [RecipeStep]
    ) {
        self.name = name
        self.ingredients = ingredients
        self.steps = steps
    }
}
