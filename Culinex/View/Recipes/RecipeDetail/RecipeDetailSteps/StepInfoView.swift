//
//  StepInfoView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/20/25.
//
import SwiftUI
import SwiftData

struct StepInfoView: View {
    let recipeStep: RecipeStep
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Step\(recipeStep.order+1)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(recipeStep.descrip)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)) // 让VStack填满行
        List{
            Section(header: Text("Duration")) {
                HStack {
                    Image(systemName: "timer")
                    Text(recipeStep.duration.formattedString)
                }
            }
            Section(header: Text("Ingredients")){
                ForEach(recipeStep.stepIngredients){ stepIngredient in
                    if let ingredient = stepIngredient.ingredient {
                        IngredientCardView(ingredient: ingredient)
                    } else {
                        Text("Missing Ingredient")
                    }
                }
            }
            Section(header: Text("Skills")){
                ForEach(recipeStep.skills){ skill in
                    SkillCardView(skill: skill)
                }
            }
        }
        .listStyle(.insetGrouped) // 使用分组列表样式，更美观
        .navigationTitle("Recipe Step Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}



//@Model // Use @Model macro to convert a Swift class into a stored model that’s managed by SwiftData.
//class RecipeStep: Identifiable { // RecipeStep is Identifiabe because it stores in arraylist
//    var descrip: String // shorten the field name
//    
//    var tools: [Tool]? // Tool is a codable struct
//    var duration: StepTime // StepTime is codable struct
//    
//    var order: Int
//    
//    @Relationship(inverse: \Skill.recipeSteps) var skills = [Skill]() // Skill is another stored model
//    
//    @Relationship(deleteRule: .cascade)
//    var stepIngredients = [RecipeIngredient]()// Ingredient is another stored model, ... to Many
//    
//    @Relationship(inverse: \Recipe.steps) var recipe: Recipe?
//
//
//    init(
//        description: String,
//        duration: StepTime,
//        order: Int
//    ) {
//        self.descrip = description
//        self.duration = duration
//        self.order = order
//    }
//}
