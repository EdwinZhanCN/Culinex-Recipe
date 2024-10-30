//
//  iCookingApp.swift
//  iCooking
//
//  Created by 詹子昊 on 2/8/24.
//

import SwiftUI
import SwiftData

@main
struct iCookingApp: App {
    let container:ModelContainer
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    init(){
        let schema = Schema([FavoriteItem.self, Recipe.self ,Ingredient.self])
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
