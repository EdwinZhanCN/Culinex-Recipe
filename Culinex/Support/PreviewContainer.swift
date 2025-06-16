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
            FavoriteItem.self,
            Recipe.self,
            Ingredient.self,
            RecipeStep.self,
            Skill.self
        ]
    )
    let config = ModelConfiguration(
        "Magic Recipe",
        schema: schema,
        isStoredInMemoryOnly: true
    )
    do {
        let container = try ModelContainer(
            for: schema, configurations: config
        )
        
        // 插入样本数据
        for skill in sampleSkills{
            container.mainContext.insert(skill)
        }
        
        for ingredient in sampleIngredients {
            container.mainContext.insert(ingredient)
        }
        
        
        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()
