//
//  IngredientCardView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/20/25.
//

import SwiftUI
import SwiftData

#if canImport(AppKit)
import AppKit
#endif

struct IngredientCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var ingredient: Ingredient
    
    private var ingredientImage: Image {
        #if canImport(UIKit)
        if let data = ingredient.image, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "carrot")
        }
        #elseif canImport(AppKit)
        if let data = ingredient.image, let nsImage = NSImage(data: data) {
            return Image(nsImage: nsImage)
        } else {
            return Image(systemName: "carrot")
        }
        #else
        return Image(systemName: "carrot")
        #endif
    }
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .font(.title2)
                .bold()
            Spacer()
            ingredientImage
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .cornerRadius(8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(colorScheme == .dark ? UIColor.systemGray5 : UIColor.systemGray6))
                .shadow(radius: 2)
        )
    }
}
