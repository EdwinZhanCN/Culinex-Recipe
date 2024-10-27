import SwiftUI
import Foundation

class IngredientsViewModel:ObservableObject{
    @Published var ingredients:[Ingredient] = []
    init() {
        // 初始化时加载示例数据
        self.ingredients = Ingredient_example
    }
}

var Ingredient_example = [
    Ingredient(name: "Tomato", image: "tomato"),
    Ingredient(name: "Egg", image: "egg"),
    Ingredient(name: "Cucumber", image: "cucumber"),
]
