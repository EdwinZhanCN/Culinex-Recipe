import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    // Unique Identifer of this data model
    @Attribute(.unique) var name: String
    // Some required attributes
    var summary: String
    var creationDate: Date

    // Define Relationship, and deleteRule
    @Relationship(deleteRule: .cascade)
    var steps = [RecipeStep]()
    
    @Relationship(inverse: \FavoriteCollection.recipes)
    var favoriteCollection: [FavoriteCollection]? // Optional relationship to a favorite item

    // Stored properties that you want to omit from writes to the persistent storage
    @Transient
    var recipeViews: Int = 0
    
    var Image: Data? // Optional image data for the recipe
    
    var calories: Int?
    
    var servingSize: Int? // Default serving size, can be adjusted later
    
    init(
        name: String,
        summary: String,
        calories: Int? = nil,
        image: Data? = nil,
        serveringSize: Int? = 1
    ) {
        self.name = name
        self.summary = summary
        self.creationDate = Date()
        self.calories = calories
        self.Image = image
        self.servingSize = serveringSize
    }
    
    var duration: Double {
        return steps.reduce(0) { total, step in
            total + step.duration.durationInSeconds
        }
    }
    
    var formattedDuration: String {
        // 将总秒数格式化为易于阅读的字符串
        let totalSeconds = Int(self.duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return "\(hours)hr \(minutes)min \(seconds)sec"
        } else if minutes > 0 {
            return "\(minutes)min \(seconds)sec"
        } else {
            return "\(seconds)sec"
        }
    }
    
    func addNewStep(description: String, duration: StepTime) {
        let newStepOrder = self.steps.count
        let newStep = RecipeStep(description: description, duration: duration, order: newStepOrder)
        self.steps.append(newStep)
    }
}


extension Recipe {
    
    /// 一个方便在购物清单中显示的结构体
    struct ShoppingListItem: Identifiable {
        var id: String { ingredient.name + unit } // 使用 食材名+单位 作为唯一标识
        let ingredient: Ingredient
        var quantity: Double
        let unit: String
        
        // 复用我们之前的格式化逻辑
        func formattedQuantity(using style: QuantityDisplayStyle = .fraction) -> String {
            switch style {
            case .decimal:
                // 小数样式：最多保留两位小数
                return String(format: "%.2f", self.quantity)
            case .fraction:
                // 分数样式：使用我们之前创建的逻辑
                let fractions: [Double: String] = [
                    0.25: "¼", 0.5: "½", 0.75: "¾",
                    0.333: "⅓", 0.666: "⅔",
                    0.125: "⅛", 0.375: "⅜", 0.625: "⅝", 0.875: "⅞"
                ]

                if quantity == floor(quantity) {
                    return "\(Int(quantity))"
                }

                let wholePart = Int(floor(quantity))
                let decimalPart = quantity - Double(wholePart)

                for (decimal, fractionChar) in fractions {
                    if abs(decimalPart - decimal) < 0.01 {
                        return wholePart == 0 ? fractionChar : "\(wholePart) \(fractionChar)"
                    }
                }
                // 如果不是常见分数，则回退到小数显示
                return String(format: "%.2f", self.quantity)
            }
        }
    }
    
    /// 计算属性：生成一个合并统计后的购物清单
    @Transient
    var shoppingList: [ShoppingListItem] {
        // 1. 使用 flatMap 将所有步骤中的所有 RecipeIngredient 拍平到一个数组中
        let allIngredients = self.steps.flatMap { $0.stepIngredients }
        
        // 2. 使用字典来进行分组和统计
        // 键是 "食材名+单位" 的组合，值是 ShoppingListItem
        var consolidatedDict = [String: ShoppingListItem]()
        
        for recipeIngredient in allIngredients {
            guard let ingredient = recipeIngredient.ingredient else { continue }
            
            let key = ingredient.name + recipeIngredient.unit
            
            // 3. 检查字典中是否已有该项
            if var existingItem = consolidatedDict[key] {
                // 如果有，累加数量
                existingItem.quantity += recipeIngredient.quantity
                consolidatedDict[key] = existingItem
            } else {
                // 如果没有，创建一个新项并添加到字典
                let newItem = ShoppingListItem(
                    ingredient: ingredient,
                    quantity: recipeIngredient.quantity,
                    unit: recipeIngredient.unit
                )
                consolidatedDict[key] = newItem
            }
        }
        
        // 4. 将字典的值转换回数组，并按食材名称排序，以便每次显示顺序都一样
        return consolidatedDict.values.sorted { $0.ingredient.name < $1.ingredient.name }
    }
}

/// Usage example:
//let newRecipeStep = RecipeStep(...) // Recipe? field wait for establish relationship
//let newRecipe = Recipe(...)// [RecipeStep]() field wait for establish relationship
//
//newRecipe.steps.append(newRecipeStep) // relationship established
//context.insert(newRecipe) // insert to context

