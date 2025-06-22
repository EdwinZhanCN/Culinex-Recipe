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
    
    init(
        name: String,
        summary: String,
        calories: Int? = nil,
    ) {
        self.name = name
        self.summary = summary
        self.creationDate = Date()
        self.calories = calories
    }
    
    var duration: Double {
        return steps.reduce(0) { total, step in
            total + step.duration.durationInSeconds
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
            // 这里可以简单地调用一个全局函数或写一个简化版的格式化逻辑
            // 为了简化，我们直接用 String(format:)
            return String(format: "%.2f", quantity) // 在视图中可以替换为更复杂的逻辑
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

