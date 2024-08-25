import Foundation

struct Recipe: Identifiable{
    var id:UUID = UUID()
    var name:String
    var ingredients:[Ingredient]
    var steps:[RecipeStep]
}
