//
//  IngredientsView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftData
import SwiftUI

struct IngredientsView: View {
    @Query var ingredients: [Ingredient]
    
    var body: some View {
        IngredientGird(ingredients: ingredients , forEditing: false)
    }
}
