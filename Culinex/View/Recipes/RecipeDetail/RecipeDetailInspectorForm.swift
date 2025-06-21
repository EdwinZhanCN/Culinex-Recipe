//
//  RecipeDetailInspectorForm.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

struct RecipeDetailInspectorForm: View {
    let recipe: Recipe
    @Binding var state: InspectorState

    var body: some View {
        // 根据 state 的不同情况，显示不同的视图
        switch state {
        case .idle:
            // 空闲时显示菜谱摘要
            Text(recipe.summary)
                .padding()
        
        case .info(let step):
            // info 状态时显示步骤详情
            StepInfoView(recipeStep: step)
        
        case .editing(let step):
            // editing 状态时显示步骤编辑器
            StepEditorForm(recipeStep: step)
        }
    }
}


