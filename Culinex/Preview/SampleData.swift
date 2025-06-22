//
//  SampleRecipes.swift
//  iCooking
//
//  Created by 詹子昊 on 10/29/24.
//
import SwiftUI
import SwiftData
import Foundation

let Chopping = Skill(name: "Chopping", ARFileName: "cup_saucer_set.usdz")

let tomatoSoupStep1 = RecipeStep(
    description: "Chop the tomatoes and onions.",
    duration: StepTime(value: 5.0, unit: .min),
    order: 0
)

let tomatoSoupStep2 = RecipeStep(
    description: "Cook the chopped tomatoes and onions in a pot.",
    duration: StepTime(value: 10.0, unit: .min),
    order: 1
)

let Tomato = Ingredient(name: "Tomato")
let TomatoUsage = RecipeIngredient(
    quantity: 500,
    unit: "g",
    ingredient: Tomato,
    step: tomatoSoupStep1
)

let Potato = Ingredient(name: "Potato")
let PotatoUsage = RecipeIngredient(
    quantity: 100,
    unit: "g",
    ingredient: Potato,
    step: tomatoSoupStep1
)

// Sample Recipe
let tomatoSoupRecipe = Recipe(
    name: "Tomato Soup",
    summary: "A simple and delicious tomato soup recipe.",
    calories: 300,
)

// Sample Favorite Collection
let sampleFavoriteCollection = FavoriteCollection(
    name: "My Favorite Recipes"
)


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


