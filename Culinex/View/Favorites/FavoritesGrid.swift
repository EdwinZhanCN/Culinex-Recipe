//
//  FavoritesGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI
import SwiftData

struct FavoritesGrid: View {
    @Query(sort: \FavoriteCollection.name) var favoriteCollections: [FavoriteCollection]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: Constants.favoriteCollectionGridSpacing) {
                ForEach(favoriteCollections, id: \.id) { collection in
                    NavigationLink(
                        destination: FavoritesDetailView(
                            favoriteCollection: collection
                        ),
                    ) {
                        FavoritesGridItemView(favoriteCollection: collection)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.leading, 20)
    }
    
    private var columns: [GridItem] {
        [ GridItem(.adaptive(minimum: Constants.favoriteCollectionGridItemMinSize,
                             maximum: Constants.favoriteCollectionGridItemMaxSize),
                   spacing: Constants.favoriteCollectionGridSpacing) ]
    }
}
