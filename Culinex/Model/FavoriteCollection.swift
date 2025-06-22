import Foundation
import SwiftData

@Model
class FavoriteCollection: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var recipes = [Recipe]()
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
