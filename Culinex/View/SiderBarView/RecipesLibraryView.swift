import SwiftUI
import SwiftData

/// RecipesLibraryView.swift
/// This is a part of SplitNavigationView, which displays a grid of recipes.
struct RecipesLibraryView: View{
    // Get all recipes from the stored data
    @Query(sort: \Recipe.name)var recipesLibrary: [Recipe]
    
    
    // There are 4 columns for the Grid View
    let columns = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
    ]
    
    // The search Text on the toolbar
    @State var searchText: String = ""
    
    // Add computed property for filtered recipes
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipesLibrary
        } else {
            return recipesLibrary.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) // allow lowercase letter
            }
        }
    }
    
    var body: some View{
        ScrollView {
            // Grid View Wrapper of Recipe Card
            LazyVGrid(columns: columns, spacing: 10) {
                // Iterate the filtered Recipes
                ForEach(filteredRecipes) { recipe in
                    // Link to the detail view
                    NavigationLink{
                        RecipeDetailView(recipe: recipe,isNewRecipe: false)
                    } label: {
                        RecipeCardView(recipe: recipe)
                    }
                }
                
                // Add Button, New Recipe
                NavigationLink{
                    // Empty steps, Empty name
                    RecipeDetailView(
                        recipe: Recipe(name: "", steps: [RecipeStep]()),
                        isNewRecipe: true
                    )
                } label: {
                    AddButton()
                }
            }
            .navigationTitle("Recipes Library")
            .searchable(text: $searchText)
            .padding()
        }
    }
}


struct RecipeCardView: View {
    var recipe: Recipe
    
    var body: some View {
        VStack{
            ZStack {
                Color.dynamicColor(for: recipe.id)
                    .frame(width: 150, height: 200)
                    .cornerRadius(8)
                
                Image(systemName: "carrot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
                    .scaleEffect(0.8)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            Text(recipe.name)
                .font(.subheadline)
        }
        .frame(maxWidth: 170)
    }
}



extension Color {
    static func dynamicColor(for id: UUID) -> Color {
        let hash = id.hashValue // 使用 name 的哈希值
        let hue = Double(abs(hash % 360)) / 360.0
        let saturation = 0.4 + Double(abs(hash % 40)) / 100.0
        let brightness = 0.5 + Double(abs(hash % 50)) / 100.0
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}

//#Preview{
//    RecipesLibraryView()
//        .modelContainer(previewContainer)
//}

