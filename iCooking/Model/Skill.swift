import Foundation
import SwiftData

@Model
class Skill: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    
    init(id: UUID = UUID(), name: String, category: String = "General") {
        self.id = id
        self.name = name
        self.category = category
    }
} 
