//
//  RecipeDetailView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//
import SwiftUI
import SwiftData

struct RecipeDetailInfoView: View {
    let recipe: Recipe
    
    @AppStorage("quantityDisplayStyle") private var displayStyle: QuantityDisplayStyle = .fraction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageData = recipe.Image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .cornerRadius(12) // 给图片加个圆角
                    .clipped()
            }
            
            Text(recipe.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(recipe.summary)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)) // 让VStack填满行
        List {
            // MARK: - 摘要信息
            Section {
                HStack {
                    Label("Total Duration", systemImage: "clock")
                    Spacer()
                    Text("\(Int(recipe.duration / 60)) min")
                        .foregroundColor(.secondary)
                }
                if let calories = recipe.calories {
                    HStack {
                        Label("Calories", systemImage: "flame")
                        Spacer()
                        Text("\(calories) kcal")
                            .foregroundColor(.secondary)
                    }
                }
            }

            // MARK: - 购物清单 (使用 IngredientCardView)
            Section(header: Text("Ingredients (Shopping List)")) {
                ForEach(recipe.shoppingList) { item in
                    // 将您的卡片视图与数量信息组合在一起
                    HStack {
                        IngredientCardView(ingredient: item.ingredient)
                        Spacer()
                        Text("\(item.formattedQuantity(using: displayStyle)) \(item.unit)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // MARK: - 所需技能 (使用 SkillCardView)
            if !recipe.allSkills.isEmpty {
                Section(header: Text("Skills")) {
                    ForEach(recipe.allSkills) { skill in
                        SkillCardView(skill: skill)
                    }
                }
            }
            
            // MARK: - 详细步骤 (导航到您的 StepInfoView)
            Section(header: Text("Steps")) {
                ForEach(recipe.steps.sorted(by: { $0.order < $1.order })) { step in
                    // 每个步骤都是一个导航链接，点击后进入您已设计好的 StepInfoView
                    NavigationLink(destination: StepInfoView(recipeStep: step)) {
                        HStack(spacing: 15) {
                            Text("\(step.order + 1)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                            
                            // 只显示步骤描述作为预览
                            Text(step.descrip)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .listStyle(.insetGrouped) // 使用分组列表样式，更美观
        .navigationTitle("Recipe Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
