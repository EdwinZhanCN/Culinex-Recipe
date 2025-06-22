//
//  SetIngredientView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//


import SwiftUI
import SwiftData

struct SetIngredientView: View {
    @Bindable var recipeStep: RecipeStep
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Ingredient.name) private var allIngredients: [Ingredient]
    @State private var showPicker = false
    @State private var editingRecipeIngredient: RecipeIngredient?
    
    // Filtered ingredients to prevent duplicates
    private var availableIngredients: [Ingredient] {
        allIngredients.filter { ingredient in
            !recipeStep.stepIngredients.contains { $0.ingredient?.id == ingredient.id }
        }
    }
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("Ingredients")
                Spacer()
                Button { showPicker = true } label: { Image(systemName: "plus") }
                    .disabled(availableIngredients.isEmpty)
            }) {
                ForEach(recipeStep.stepIngredients) { ri in
                    HStack {
                        Text(ri.ingredient?.name ?? "Unknown")
                        Spacer()
                        Button("Edit") { editingRecipeIngredient = ri }
                    }
                }
                .onDelete { offsets in
                    offsets.map { recipeStep.stepIngredients[$0] }
                           .forEach(modelContext.delete)
                    recipeStep.stepIngredients.remove(atOffsets: offsets)
                    try? modelContext.save()
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                if availableIngredients.isEmpty {
                    Text("All ingredients have been added to this step")
                        .padding()
                } else {
                    List {
                        ForEach(availableIngredients) { ing in
                            Button {
                                let newRI = RecipeIngredient(
                                    quantity: 1,
                                    unit: "g",
                                    ingredient: ing,
                                    step: recipeStep
                                )
                                
                                modelContext.insert(newRI)
                                recipeStep.stepIngredients.append(newRI)
                                try? modelContext.save()
                                
                                showPicker = false
                                editingRecipeIngredient = newRI
                            } label: {
                                Text(ing.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Ingredient")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showPicker = false }
                }
            }
        }
        .sheet(item: $editingRecipeIngredient) { ri in
            if let ing = ri.ingredient {
                IngredientEditView(recipeIngredient: ri, ingredient: ing)
            } else {
                EmptyView()
            }
        }
    }
}

struct IngredientEditView: View {
    // @Bindable 适用于 @Model 对象
    @Bindable var recipeIngredient: RecipeIngredient
    @Bindable var ingredient: Ingredient
    
    @State private var isPickerPresented = false
    
    // 1. 从 AppStorage 读取用户的全局显示偏好
    // 如果用户从未设置过，则默认为 .fraction (分数)
    @AppStorage("quantityDisplayStyle") private var displayStyle: QuantityDisplayStyle = .fraction

    var body: some View {
        Form {
            Section(header: Text("Ingredient Info")) {
                TextField("Name", text: $ingredient.name)
            }
            
            Section(header: Text("For this Recipe")) {
                Button(action: {
                    isPickerPresented = true
                }) {
                    HStack {
                        Text("Quantity")
                            .foregroundColor(.primary)
                        Spacer()
                        // 2. 调用模型的新方法，并传入当前的全局设置
                        Text(recipeIngredient.format(using: displayStyle))
                            .foregroundColor(.accentColor)
                            .font(.headline)
                    }
                }
                
                HStack {
                    Text("Unit")
                    Spacer()
                    TextField("Unit", text: $recipeIngredient.unit)
                        .multilineTextAlignment(.trailing) // 使文本靠右对齐
                        .frame(width: 120) // 给一个合适的宽度
                }
            }
            
            // MARK: - 新增：让用户切换显示样式的设置
            Section(header: Text("Display Settings")) {
                // 3. 创建一个 Picker，直接绑定到 @AppStorage 变量
                Picker("Quantity Display", selection: $displayStyle) {
                    ForEach(QuantityDisplayStyle.allCases, id: \.self) { style in
                        Text(style.label).tag(style)
                    }
                }
                .pickerStyle(.segmented) // 分段样式看起来很棒
            }
        }
        .navigationTitle("Edit Ingredient")
        .sheet(isPresented: $isPickerPresented) {
            CalculatorNumberPickerView(quantity: $recipeIngredient.quantity)
        }
    }
}



