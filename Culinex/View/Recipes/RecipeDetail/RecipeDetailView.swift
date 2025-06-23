//
//  RecipeDetailView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

enum InspectorState: Hashable {
    case idle
    case info(RecipeStep)
    case editing(RecipeStep)
}

struct RecipeDetailView: View {
    // passing the recipe model from parent to the view
    @Bindable var recipe: Recipe
    
    // 单一的状态源，管理所有检查器相关的状态
    @State private var inspectorState: InspectorState = .idle
    @State private var inspectorPresented: Bool = false

    var body: some View {
        RecipeDetailStepsView(
            recipe: recipe,
            state: $inspectorState, // 传递 state 的绑定
            inspectorPresented: $inspectorPresented // 传递 inspectorPresented 的绑定
        )
        .inspector(isPresented: $inspectorPresented) {
            RecipeDetailInspectorForm(
                recipe: recipe,
                state: $inspectorState // 同样传递 state 的绑定
            )
            .inspectorColumnWidth(225)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    print("Share tapped")
                } label: {
                    Label("Recipe Info", systemImage: "square.and.arrow.up")
                }
            }
                        
            ToolbarItem{
                Button {
                    inspectorPresented = true
                    inspectorState = .idle
                } label: {
                    Label("Recipe Info", systemImage: "info")
                }
            }
            ToolbarItem {
                Button {
                    inspectorPresented.toggle()
                } label: {
                    Label("Toggle Inspector", systemImage: "sidebar.trailing")
                }
            }
        }
    }
}
