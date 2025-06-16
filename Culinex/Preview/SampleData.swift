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
    Ingredient(
        name: "Tomato",
        image: UIImage(named:"tomato")!.jpegData(compressionQuality: 1.0)
    ),
    Ingredient(name: "Onion", image: UIImage(named:"onion")!.jpegData(compressionQuality: 1.0)),
    Ingredient(name: "Garlic", image: UIImage(named:"garlic")!.jpegData(compressionQuality: 1.0)),
    Ingredient(name: "Basil", image: UIImage(named:"basil")!.jpegData(compressionQuality: 1.0)),
    Ingredient(name: "Olive Oil", image: UIImage(named:"olive_oil")!.jpegData(compressionQuality: 1.0))
]


// Sample Data for Skill
let sampleSkills: [Skill] = [
    Skill(name: "Chopping", category: "Kitchen Skills", ARFileName: "cup_saucer_set"),
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


