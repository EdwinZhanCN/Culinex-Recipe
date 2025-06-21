//
//  RecipeDetailStepEditorForm.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

struct StepEditorForm: View {
    let recipeStep: RecipeStep
    @State private var selection: StepEditorFormOptions = .setDescription
    let shouldShowBadge = true

    var body: some View {
        VStack(spacing: 0) {
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
            case .setIngredients: SetIngredientView()
            case .setTools: SetToolsView()
            case .setTimer: SetTimerView()
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
struct SetDescriptionView: View {
    var body: some View {
        Text("Set Description View").font(.title)
    }
}

struct SetIngredientView: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        GenericLibraryListView(
            sort: SortDescriptor(\Ingredient.name),
            navigationTitle: "Ingredients",
        )
    }
}

struct SetToolsView: View {
    var body: some View {
        Text("Set Tools View").font(.title)
    }
}

struct SetTimerView: View {
    var body: some View {
        Text("Set Timer View").font(.title)
    }
}

struct SetSkillView: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        GenericLibraryListView(
            sort: SortDescriptor(\Skill.name),
            navigationTitle: "Skill",
        )
    }
}

