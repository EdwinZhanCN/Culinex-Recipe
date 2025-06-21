import Foundation
import SwiftData
import SwiftUI

@Model
class Ingredient: Identifiable, LibraryItem {
    @Attribute(.unique) var name: String
    var image: Data?
    
    var displayName: String {
        return self.name
    }
    
    init(name: String, image: Data? = nil) {
        self.name = name
        self.image = image
    }
}
