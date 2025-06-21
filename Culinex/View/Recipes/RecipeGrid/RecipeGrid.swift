//
//  RecipeGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct RecipeGrid: View {
    // Get all recipes from parent view
    var recipes: [Recipe]
    // The search Text on the toolbar
    @State var searchText: String = ""
    let forEditing: Bool
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredRecipes) { recipe in
                    // Link to the detail view
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeGridItemView(recipe: recipe)
                    }
                }
                
            }
            .navigationTitle("Recipes Library (\(recipes.count) total)")
            .searchable(text: $searchText)
            .padding(20)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        RecipeDetailView(
                            recipe: Recipe(name: "Hello",summary: "Hello New Recipe",)
                        )
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(.blue)
                            
                    }
                }
            }
        }
    }
    
    private var columns: [GridItem] {
        if forEditing {
            return [ GridItem(.adaptive(minimum: Constants.recipeGridItemEditingMinSize,
                                        maximum: Constants.recipeGridItemEditingMaxSize),
                              spacing: Constants.recipeGridSpacing) ]
        }
        return [ GridItem(.adaptive(minimum: Constants.recipeGridItemMinSize,
                                    maximum: Constants.recipeGridItemMaxSize),
                          spacing: Constants.recipeGridSpacing) ]
    }
}
