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
    
    private var durationText: String {
        let value = recipeStep.duration.value
        let unit = recipeStep.duration.unit
        return "\(value) \(unit.toString(value: value))"
    }
    
    var body: some View {
        Text("Step \(recipeStep.order+1)")
            .font(.title)
            .fontWeight(.bold)
        Text(recipeStep.descrip)
            .font(.body)
            .padding(.bottom, 10)
        List{
            
            Section(header: Text("Duration")) {
                HStack {
                    Image(systemName: "timer")
                    Text(durationText)
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
