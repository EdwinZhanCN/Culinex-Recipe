//
//  Step.swift
//  iCooking
//
//  Created by 詹子昊 on 2/12/24.
//

import Foundation

struct RecipeStep:Identifiable{
    var id:UUID = UUID()
    var ingredients:[Ingredient] = []
    var description:String = "No description"
    var skills:[String] = []
    var tools:[String] = []
    var duration:[StepTime] = []
}

var Descriprion_Example = "Using knife to chop the tomatoes on the chopping board."
var Skills_Example = ["Chop"]
var Tools_Example = ["Knife", "Chopping Board"]
var Time_Example = [StepTime(value: 5.0, unit: .minute)]
