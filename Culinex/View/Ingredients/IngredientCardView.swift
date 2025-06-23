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
    @State private var showFullText = false
    
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
                .font(.body)
                .bold()
                .lineLimit(3)
                .onTapGesture {
                    showFullText = true
                }
                // 3. 附加 popover 修饰符
                .popover(isPresented: $showFullText, arrowEdge: .leading) {
                    // 这是浮窗中显示的内容
                    VStack {
                        Text(ingredient.name)
                            .font(.headline)
                            .padding()
                        Button("Close") {
                            showFullText = false
                        }
                        .padding(.bottom)
                    }
                    // 在 iOS 16.4+ 上可以设置浮窗的大小
                    .presentationCompactAdaptation(.popover)
                }
            Spacer()
            ingredientImage
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
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
