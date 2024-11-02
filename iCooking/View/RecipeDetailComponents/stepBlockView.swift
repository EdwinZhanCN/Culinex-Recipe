//
//  stepBlockView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct stepBlockView: View {
    var recipeStep: RecipeStep
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipeStep.descrip)
                .foregroundStyle(.white)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.tertiary)
                        .opacity(0.8)
                )
                .padding(.vertical, 10)
                .padding(.horizontal,5)
            HStack {
                VStack(alignment: .leading) {
                    if !recipeStep.skills.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recipeStep.skills) { skill in
                                    HStack {
                                        Text(skill.name)
                                        Text(skill.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .foregroundStyle(.orange.opacity(0.5))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    if !recipeStep.ingredients.isEmpty{
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(recipeStep.ingredients){ingredient in
                                    Text(ingredient.name)
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
                
                //duration
                VStack{
                    let durationValue = recipeStep.duration.value
                    let durationString = "\(String(format: "%.1f", durationValue)) \(recipeStep.duration.unit.toString(value: durationValue))"
                    
                    Spacer()
                    Label(
                        durationString,
                        systemImage: "timer"
                    )
                    .font(.title3)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tertiary)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
