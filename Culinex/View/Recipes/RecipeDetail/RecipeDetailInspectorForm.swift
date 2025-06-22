//
//  RecipeDetailInspectorForm.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

struct RecipeDetailInspectorForm: View {
    @Bindable var recipe: Recipe
    @Binding var state: InspectorState
    @Environment(\.modelContext) private var context

    var body: some View {
        // 根据 state 的不同情况，显示不同的视图
        switch state {
        case .idle:
            RecipeDetailInfoView(recipe: recipe)
        case .info(let step):
            // info 状态时显示步骤详情
            StepInfoView(recipeStep: step)
        case .editing(let step):
            // editing 状态时显示步骤编辑器
            StepEditorForm(recipeStep: step)
                .toolbar{
                    Button{
                        saveChanges()
                    } label: {
                        Text("Done")
                            .foregroundStyle(.blue)
                    }
                }
        }
    }
    
    private func saveChanges() {
        // 保存修改
        do {
            try context.save()
            state = .idle // 保存后返回到 idle 状态
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}


