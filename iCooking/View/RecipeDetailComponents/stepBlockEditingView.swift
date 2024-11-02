//
//  stepBlockEditingView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct stepBlockEditingView:View{
    @Binding var discription: String
    @Binding var skills:[Skill]
    @Binding var ingredients:[Ingredient]
    @Binding var durationValue:Double
    @Binding var durationUnit:UnitOfTime
    var body: some View{
        VStack(alignment:.leading){
            //display the discription
            if !discription.isEmpty{
                Text(discription)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.tertiary)
                            .opacity(0.8)

                            
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal,5)
            } else{
                Text("Use tools on the right to create a new Step!")
                    .font(.title)
            }
            HStack{
                // display the custom skills, and skills extracted from the description
                VStack(alignment: .leading){
                    if !skills.isEmpty{
                        ScrollView{
                            HStack{
                                ForEach(skills){skill in
                                    Text(skill.name)
                                        .padding(5)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .foregroundStyle(.orange)
                                                .opacity(0.5)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    if !ingredients.isEmpty{
                        ScrollView{
                            HStack{
                                ForEach(ingredients){ingredient in
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
                    let durationValue = durationValue.isNaN ? 0 : durationValue
                    let durationString = "\(String(format: "%.1f", durationValue)) \(durationUnit.toString(value: durationValue))"
                    
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