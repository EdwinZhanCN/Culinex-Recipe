//
//  PreviewSampleData.swift
//  iCooking
//
//  Created by 詹子昊 on 10/30/24.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let schema = Schema(
        [
            FavoriteCollection.self,
            Recipe.self,
            Ingredient.self,
            RecipeStep.self,
            Skill.self
        ]
    )
    let config = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: true
    )
    do {
        let container = try ModelContainer(
            for: schema, configurations: config
        )
        
        // 插入样本数据
        // 1. 建立 Step <-> Ingredient 的关系
        // 这是最关键和缺失的一步！
        tomatoSoupStep1.stepIngredients.append(TomatoUsage)
        tomatoSoupStep1.stepIngredients.append(PotatoUsage)
        

        // 2. 建立其他关系
        tomatoSoupStep1.skills.append(Chopping)
        tomatoSoupRecipe.steps.append(tomatoSoupStep1)
        tomatoSoupRecipe.steps.append(tomatoSoupStep2)

        // 3. 将所有独立的 @Model 对象插入 Context
        // 注意：因为 RecipeIngredient 的关系设置了 .cascade，
        // 当 tomatoSoupStep1 被插入时，其 stepIngredients 数组中的 TomatoUsage 也会被自动插入。
        // 但为了代码清晰，显式插入所有根对象或独立对象是好习惯。
        container.mainContext.insert(Tomato)
        container.mainContext.insert(Chopping) // Skill 如果是独立可重用的，也应该被插入
        container.mainContext.insert(tomatoSoupRecipe)
        
        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()
