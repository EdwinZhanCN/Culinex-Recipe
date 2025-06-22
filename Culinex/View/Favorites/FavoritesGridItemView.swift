//
//  FavoritesGridItem.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI
import SwiftData

struct FavoritesGridItemView: View {
    var favoriteCollection: FavoriteCollection
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(backgroundColor)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay {
                    GeometryReader { geometry in
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                            .offset(x: geometry.size.width / 4, y: geometry.size.height / 4)
                            #if os(iOS)
                            .foregroundColor(Color(uiColor: .systemGray3))
                            #endif
                            #if os(macOS)
                            .foregroundColor(Color(nsColor: .secondaryLabelColor).opacity(0.3))
                            #endif
                    }
                }
            Text(favoriteCollection.name)
            Text("\(favoriteCollection.recipes.count) items")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}

extension FavoritesGridItemView {
    
    var backgroundColor: some ShapeStyle {
#if os(iOS)
        return Color(uiColor: .systemGray5)
#endif
#if os(macOS)
        return Color(nsColor: .secondarySystemFill)
#endif
    }
}
