//
//  RecipeGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import SwiftData

struct RecipeGrid: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    // Get all recipes from parent view
    var recipes: [Recipe]
    // The search Text on the toolbar
    @State var searchText: String = ""
    @State private var isEditing = false
    @State private var selection = Set<Recipe>()
    @State private var showConfirmationDialog = false
    let forEditing: Bool
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredRecipes) { recipe in
                    if isEditing {
                        RecipeGridEditingView(recipe: recipe, isEditing: $isEditing, selection: $selection)
                    } else {
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeGridItemView(recipe: recipe)
                        }
                    }
                }
                
            }
            .navigationTitle("Recipes Library (\(recipes.count) total)")
            .searchable(text: $searchText)
            .padding(20)
            .toolbar {
                RecipeGridToolbar(
                    isEditing:$isEditing,
                    showConfirmationDialog: $showConfirmationDialog,
                    selection: selection
                ){
                    print("Add button tapped")
                } toggleEdit: {
                    isEditing.toggle()
                    selection.removeAll()
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .alert("Delete?", isPresented: $showConfirmationDialog) {
            Button(role: .destructive) {
                // Remove collection from model data
                deleteSelectedRecipes()
                dismiss()
            } label: {
                Text("Delete", comment: "Delete button shown in an alert asking for confirmation to delete the collection.")
            }
            Button("Keep") {
                showConfirmationDialog = false
            }
        } message: {
            Text("Select Delete to permanently remove all recipes you selected.",
                 comment: "Message in an alert asking the person whether they want to delete a collection with a given name.")
        }
    }
    
    private func deleteRecipe(_ recipe: Recipe) {
        modelContext.delete(recipe)
    }
    
    private func deleteSelectedRecipes() {
        withAnimation {
            selection.forEach { recipe in
                modelContext.delete(recipe)
            }
            selection.removeAll()
        }
    }
    
    private var columns: [GridItem] {
        if forEditing {
            return [ GridItem(.adaptive(minimum: Constants.recipeGridItemEditingMinSize,
                                        maximum: Constants.recipeGridItemEditingMaxSize),
                              spacing: Constants.recipeGridSpacing) ]
        }
        return [ GridItem(.adaptive(minimum: Constants.recipeGridItemMinSize,
                                    maximum: Constants.recipeGridItemMaxSize),
                          spacing: Constants.recipeGridSpacing) ]
    }
}


struct RecipeGridEditingView: View {
    var recipe: Recipe
    @Binding var isEditing: Bool
    @Binding var selection: Set<Recipe>
    var body: some View {
        RecipeGridItemView(recipe: recipe)
            .overlay(
                Group {
                    if selection.contains(recipe) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 6)
                    }
                }
            )
            .onTapGesture {
                if selection.contains(recipe) {
                    selection.remove(recipe)
                } else {
                    selection.insert(recipe)
                }
            }
    }
}


struct RecipeGridToolbar: ToolbarContent {
    @Binding var isEditing: Bool
    @Binding var showConfirmationDialog: Bool
    let selection: Set<Recipe>
    let add: () -> Void
    let toggleEdit: () -> Void
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Button(isEditing ? "Done" : "Edit", action: toggleEdit)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if isEditing {
                if !selection.isEmpty {
                    Button(role: .destructive) {
                        showConfirmationDialog.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            } else {
                Button(action: add){
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}
