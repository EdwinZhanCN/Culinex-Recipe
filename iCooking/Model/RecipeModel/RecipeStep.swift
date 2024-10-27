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
}
var Descriprion_Example = "This is a sample step"
var Skills_Example = ["Slice"]
var Tools_Example = ["Pan"]
var Time_Example = [StepTime(value: 5.0, unit: .minute)]
