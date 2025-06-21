//
//  RecipesView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct RecipesView: View {
    @Query(sort: \Recipe.name, order: .forward) var recipes: [Recipe]
    
    var body: some View {
        RecipeGrid(recipes: recipes, forEditing: false)
    }
}

