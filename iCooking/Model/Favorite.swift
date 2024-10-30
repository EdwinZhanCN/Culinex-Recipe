import Foundation
import SwiftData


@Model
class FavoriteItem: Identifiable{
    @Attribute(.unique) var id: UUID
    var name:String
    var recipes:[Recipe]
    
    init(id: UUID = UUID(),name: String, recipes: [Recipe]) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
}
