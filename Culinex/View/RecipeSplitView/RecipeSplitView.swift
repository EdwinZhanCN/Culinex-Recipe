//
//  RecipeSplitView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData
/// A split view establishes navigation for the app
struct RecipeSplitView: View{
    @Environment(\.modelContext) var context
    @State private var preferredColumn: NavigationSplitViewColumn = .detail
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                Section {
                    ForEach(NavigationOptions.mainPages) { page in
                        NavigationLink(value: page) {
                            Label {
                                Text(page.name) // 将 LocalizedStringResource 传递给 Text
                            } icon: {
                                Image(systemName: page.symbolName)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: NavigationOptions.self){ page in
                NavigationStack (path: $path){
                    // root view for the page
                    page.viewForPage()
                }
                .navigationDestination(for: Recipe.self){ recipe in
                    RecipeDetailView(recipe: recipe)
                } // TODO: More navigation destinations as needed
            }
            .frame(minWidth: 150)
        } detail: {
            NavigationStack(path: $path) {
                NavigationOptions.recipes.viewForPage()
            }
            .navigationDestination(for: Recipe.self){ recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}
