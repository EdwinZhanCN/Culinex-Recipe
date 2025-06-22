
//
//  RecipeGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI

struct IngredientGird: View {
    // Get all recipes from parent view
    var ingredients: [Ingredient]
    // The search Text on the toolbar
    @State var searchText: String = ""
    let forEditing: Bool
    
    var filteredingredients: [Ingredient] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredingredients) { ingredient in
                    // Link to the detail view
                    NavigationLink(destination: Text("Ingredient Detail View")) {
                        IngredientCardView(ingredient: ingredient)
                    }
                }
                
            }
            .navigationTitle("Recipes Library (\(ingredients.count) total)")
            .searchable(text: $searchText)
            .padding(20)
        }
    }
    
    private var columns: [GridItem] {
        if forEditing {
            return [ GridItem(.adaptive(minimum: Constants.ingredientGridItemEditingMinSize,
                                        maximum: Constants.ingredientGridEditingMaxSize),
                              spacing: Constants.ingredientGridSpacing) ]
        }
        return [ GridItem(.adaptive(minimum: Constants.ingredientGridItemMinSize,
                                    maximum: Constants.ingredientGridItemMaxSize),
                          spacing: Constants.ingredientGridSpacing) ]
    }
}
