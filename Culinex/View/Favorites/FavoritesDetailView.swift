//
//  FavoritesDetailView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI

struct FavoritesDetailView: View {
    var favoriteCollection: FavoriteCollection
    @State private var isEditing: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                if isEditing {
                    Text("Editing Favorites")
                } else {
                    FavoritesDetailDisplayView(collection: favoriteCollection)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}


struct FavoritesDetailDisplayView: View {
    var collection: FavoriteCollection
    
    var body: some View {
        VStack() {
            HStack {
                Text(collection.name)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.leading, 20)
                Spacer()
            }
            RecipeGrid(recipes: collection.recipes, forEditing: false)
        }
    }
}
