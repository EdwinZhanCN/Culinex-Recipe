import Foundation
import SwiftData

@Model
class Ingredient: Identifiable{
    @Attribute(.unique) var id: UUID
    var name:String
    var image:String?
    
    init(id: UUID = UUID(), name: String, image: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}

