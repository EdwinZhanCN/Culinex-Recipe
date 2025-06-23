import Foundation
import SwiftData

@Model
class FavoriteCollection: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var isDeletable: Bool
    
    var recipes = [Recipe]()
    
    // ✅ 使用计算属性和 guard let 来安全地创建静态 UUID
    // 这样可以保证 favoritesID 永远是一个非可选的 UUID
    static let favoritesID: UUID = {
        guard let uuid = UUID(uuidString: "E1F3C4B5-A6D7-4E8F-9A0B-1C2D3E4F5A6B") else {
            // 如果 UUID 字符串格式错误，这会立即在开发时暴露问题，而不是在用户设备上闪退
            fatalError("Invalid UUID string provided for favoritesID")
        }
        return uuid
    }()
    
    init(id: UUID = UUID(), name: String, isDeletable: Bool = true) {
        self.id = id
        self.name = name
        self.isDeletable = isDeletable
    }
    
    func addRecipe(_ recipe: Recipe) -> String{
        if !recipes.contains(where: { $0.id == recipe.id }) {
            recipes.append(recipe)
            return "Recipe added to \(name)"
        }
        return "Recipe already exists in \(name)"
    }
}
