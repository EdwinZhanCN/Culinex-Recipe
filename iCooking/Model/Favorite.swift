import Foundation

class FavoriteItem: Identifiable{
    var id:UUID = UUID()
    var name:String
    var recipes:[Recipe]
    
    init(name: String, recipes: [Recipe]) {
        self.name = name
        self.recipes = recipes
    }
}
