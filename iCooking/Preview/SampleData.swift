//
//  SampleRecipes.swift
//  iCooking
//
//  Created by 詹子昊 on 10/29/24.
//
import SwiftUI
import SwiftData
import Foundation

// Sample Data for Ingredient
let sampleIngredients: [Ingredient] = [
    Ingredient(name: "Tomato", image: "tomato"),
    Ingredient(name: "Onion", image: "onion"),
    Ingredient(name: "Garlic", image: "garlic"),
    Ingredient(name: "Basil", image: "basil"),
    Ingredient(name: "Olive Oil", image: "olive_oil")
]

let arObjectData = loadRealityFile(named: "hab_en")

// Sample Data for Skill
let sampleSkills: [Skill] = [
    Skill(name: "Chopping", category: "Kitchen Skills", ARObject: arObjectData),
    Skill(name: "Crushing", category: "Kitchen Skills")
]

func loadRealityFile(named fileName: String) -> Data? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "reality") else {
        print("Failed to find .reality file named \(fileName)")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        return data
    } catch {
        print("Error loading .reality file: \(error)")
        return nil
    }
}


