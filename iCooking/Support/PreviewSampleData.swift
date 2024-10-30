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
    let schema = Schema([FavoriteItem.self, Recipe.self, Ingredient.self, RecipeStep.self])
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
        for recipe in sampleRecipes {
            container.mainContext.insert(recipe)
        }
        for ingredient in sampleIngredients {
            container.mainContext.insert(ingredient)
        }
        for favoriteItem in sampleFavoriteItems {
            container.mainContext.insert(favoriteItem)
        }
        
        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()
