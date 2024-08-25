import SwiftUI
import Foundation

class RecipesViewModel: ObservableObject{
    @StateObject private var ingredientsViewModel = IngredientsViewModel()
    @Published var recipesLibrary:[Recipe] = Recipe_example
    private var steps:[RecipeStep] = []
}

var Step_example = [RecipeStep(description: Descriprion_Example,
                               skills: Skills_Example,
                               tools: Tools_Example
                              )]

var Recipe_example = [
    Recipe(name: "Fired eggs and tomato", ingredients: Ingredient_example,steps: Step_example)
]


