//
//  Untitled.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailStepsView: View {
    let recipe: Recipe
    @Binding var state: InspectorState

    private var sortedSteps: [RecipeStep] {
        recipe.steps.sorted { $0.order < $1.order }
    }
    
    // 从主状态计算出 List 的 selection 绑定
    private var selection: Binding<RecipeStep?> {
        Binding<RecipeStep?>(
            get: {
                if case .info(let step) = state {
                    return step
                }
                return nil
            },
            set: { newSelection in
                if let newSelection = newSelection {
                    state = .info(newSelection)
                } else {
                    state = .idle
                }
            }
        )
    }
    
    private var isEditing: Bool {
        if case .editing = state {
            return true
        }
        return false
    }

    var body: some View {
        List(selection: selection) {
            ForEach(sortedSteps) { step in
                Section(header:
                    HStack {
                        Text("Step \(step.order + 1)")
                        Spacer()
                        Button(action: {
                            state = .editing(step)
                        }) {
                            Image(systemName: "pencil")
                                .imageScale(.medium)
                        }
                        .buttonStyle(.borderless)
                    }
                ) {
                    Text(step.descrip).tag(step)
                    IngredientHScrollView(
                        recipeIngredient: step.stepIngredients
                    )
                }
            }
        }
        .disabled(isEditing)
    }
}



struct IngredientHScrollView: View {
    let recipeIngredient: [RecipeIngredient]
    var onDrop: ((PersistentIdentifier) -> Void)? = nil
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(recipeIngredient) { recipeIngredient in
                    HStack{
                        Text(recipeIngredient.ingredient.name)
                        Text("\(recipeIngredient.quantity, specifier: "%.1f") \(recipeIngredient.unit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(5)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.link)
                    )
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

