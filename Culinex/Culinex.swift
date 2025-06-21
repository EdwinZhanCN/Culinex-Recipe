//
//  iCookingApp.swift
//  iCooking
//
//  Created by 詹子昊 on 2/8/24.
//

import SwiftUI
import SwiftData

@main
struct Culinex: App {
    let container:ModelContainer
    // navigation path for whole app
    @State private var navigationPath = NavigationPath()
    
    
    var body: some Scene {
        WindowGroup {
            RecipeSplitView(path: $navigationPath)
        }
//        .modelContainer(container)
        .modelContainer(previewContainer)
    }
    init(){
        let schema = Schema(
            [FavoriteCollection.self, Recipe.self ,Ingredient.self,Skill.self]
        )
        let config = ModelConfiguration("Magic Recipe", schema: schema)
        do{
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        
        
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//        print(URL.documentsDirectory.path())
    }
}
