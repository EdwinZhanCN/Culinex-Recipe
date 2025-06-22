//
//  Untitled.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailStepsView: View {
    @Bindable var recipe: Recipe
    @Binding var state: InspectorState
    @Binding var inspectorPresented: Bool

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
                            if !inspectorPresented {
                                inspectorPresented = true
                            }
                        }) {
                            Image(systemName: "pencil")
                                .imageScale(.medium)
                        }
                        .buttonStyle(.borderless)
                    }
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(step.descrip).tag(step)
                        IngredientHScrollView(step: step)
                        SkillHScrollView(step: step)
                    }
                }
                .tag(step)
            }
        }
        .disabled(isEditing)
        .listRowSeparator(.hidden)
    }
}



import SwiftUI

struct IngredientHScrollView: View {
    // 接收整个 Step 对象，它是一个可观察的数据源
    @State var step: RecipeStep

    // 将原有的数组排序逻辑（如果需要）移到这里
    private var sortedIngredients: [RecipeIngredient] {
        // 如果你的 RecipeIngredient 需要排序，可以在这里处理
        step.stepIngredients.sorted { $0.ingredient?.name ?? "" < $1.ingredient?.name ?? "" }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                // 直接在 body 中访问 step.stepIngredients
                // SwiftUI 会确保当它变化时，body 会被重新渲染
                ForEach(sortedIngredients) { recipeIngredient in
                    HStack{
                        Text(recipeIngredient.ingredient?.name ?? "Unknown Ingredient")
                        // 你的格式化字符串可能需要调整，这里假设 quantity 是 Double
                        Text("\(recipeIngredient.quantity, specifier: "%.1f") \(recipeIngredient.unit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(5)
                    .foregroundStyle(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.indigo)
                    )
                }
            }
        }
    }
}

struct SkillHScrollView: View {
    @State var step: RecipeStep
    
    private var sortedSkills: [Skill] {
        // 如果你的 RecipeIngredient 需要排序，可以在这里处理
        step.skills.sorted { $0.name < $1.name }
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(sortedSkills) { skill in
                    HStack{
                        Text(skill.name)
                        Text(skill.category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(5)
                    .foregroundStyle(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.orange)
                    )
                }
            }
        }
    }
}

