//
//  RecipeDetailStepEditorForm.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct StepEditorForm: View {
    @Bindable var recipeStep: RecipeStep
    @State private var selection: StepEditorFormOptions = .setDescription
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var shouldShowBadge: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            buttonGrid
            Divider()
            contentArea
        }
    }

    
    private var buttonGrid: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            
            let allOptions = StepEditorFormOptions.allCases
            
            GridRow {
                if allOptions.indices.contains(0) {
                    createButton(for: allOptions[0])
                }
                if allOptions.indices.contains(1) {
                    createButton(for: allOptions[1])
                }
            }
            GridRow {
                if allOptions.indices.contains(2) {
                    createButton(for: allOptions[2])
                }
                if allOptions.indices.contains(3) {
                    createButton(for: allOptions[3])
                }
            }
            GridRow {
                if let lastOption = allOptions.last {
                    createButton(for: lastOption)
                        .gridCellColumns(2)
                }
            }

        }
        .padding()
    }
    
    @ViewBuilder
    private var contentArea: some View {
        ZStack {
            switch selection {
            case .setDescription: SetDescriptionView()
            case .setIngredients: SetIngredientView(recipeStep: recipeStep)
            case .setTools: SetToolsView()
            case .setTimer: SetTimerView(recipeStep: recipeStep)
            case .setSkills: SetSkillView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func createButton(for option: StepEditorFormOptions) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = option
            }
        } label: {
            VStack {
                Image(systemName: option.symbolName)
                    .font(.title2)
                    .foregroundStyle(option.symbolColor)
                Text(option.title)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(selection == option ? Color.accentColor : Color.secondary.opacity(0.15))
            .foregroundColor(selection == option ? .white : .primary)
            .cornerRadius(10)
            .overlay(alignment: .topTrailing) {
                if shouldShowBadge {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(.white, .green)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// 您的占位符视图，保持不变









