import SwiftUI
import Foundation

class IngredientsViewModel:ObservableObject{
    @Published var ingredients:[Ingredient] = []
}

var Ingredient_example = [
    Ingredient(name: "Tomato"),
    Ingredient(name: "Egg")
]
