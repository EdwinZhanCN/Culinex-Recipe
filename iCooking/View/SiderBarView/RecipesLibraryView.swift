import SwiftUI
import SwiftData

struct RecipesLibraryView: View{
    @Query(sort: \Recipe.name)var recipesLibrary: [Recipe]
    
    let columns = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
    ]
    
    @State var searchText: String = ""
    
    // Add computed property for filtered recipes
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipesLibrary
        } else {
            return recipesLibrary.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View{
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredRecipes) { recipe in
                    NavigationLink{
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        RecipeCardView(recipe: recipe)
                    }
                }
                NavigationLink{
                    RecipeCreationView()
                } label: {
                    RecipeAddCardView()
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
                Color.dynamicColor(for: recipe.name)
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


struct RecipeAddCardView: View {
    var body: some View {
        VStack{
            ZStack {
                Color.gray
                    .frame(width: 150, height: 200)
                    .cornerRadius(8)
                
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
                    .scaleEffect(0.8)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            Text("New Recipe")
                .font(.subheadline)
        }
        .frame(maxWidth: 170)
    }
}

extension Color {
    static func dynamicColor(for name: String) -> Color {
        let hash = name.hashValue // 使用 name 的哈希值
        let hue = Double(abs(hash % 360)) / 360.0
        let saturation = 0.4 + Double(abs(hash % 40)) / 100.0
        let brightness = 0.5 + Double(abs(hash % 50)) / 100.0
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}

#Preview{
    RecipesLibraryView()
        .modelContainer(previewContainer)
}

