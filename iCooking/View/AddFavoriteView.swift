import SwiftUI
import SwiftData

struct AddFavoriteView: View {
    @Query var favorites: [FavoriteItem]
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
        
    @State private var favoriteName: String = ""
    @State private var showBottomSheet: Bool = false
    @State private var showAlert = false
    @State private var selectedRecipes: [Recipe] = []
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented{
            NavigationView {
                VStack {
                    // Recipe List Section
                    if selectedRecipes.isEmpty {
                        emptyStateView
                    } else {
                        recipeListView
                    }
                    
                    Spacer()
                }
                .navigationTitle("New Favorite")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        TextField("Favorite Name", text: $favoriteName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveNewFavorite()
                        }
                        .disabled(selectedRecipes.isEmpty)
                    }
                }
                .sheet(isPresented: $showBottomSheet) {
                    RecipeSelectionSheet(
                        selectedRecipes: $selectedRecipes,
                        isPresented: $showBottomSheet
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }
                .alert("No Recipes Selected", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Please select at least one recipe")
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("Create a collection of your favorite recipes!")
                .foregroundStyle(.secondary)
                .bold()
            
            Button {
                showBottomSheet = true
            } label: {
                Label("Add Recipes", systemImage: "plus.circle.fill")
                    .font(.title3)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private var recipeListView: some View {
        List {
            ForEach(selectedRecipes) { recipe in
                Text(recipe.name)
            }
            .onDelete { indexSet in
                selectedRecipes.remove(atOffsets: indexSet)
            }
            .onMove { from, to in
                selectedRecipes.move(fromOffsets: from, toOffset: to)
            }
            
            Button {
                showBottomSheet = true
            } label: {
                Label("Add More", systemImage: "plus")
            }
        }
        .toolbar {
            EditButton()
        }
    }
    
    private func saveNewFavorite() {
        guard !selectedRecipes.isEmpty else {
            showAlert = true
            return
        }
        
        let name = favoriteName.isEmpty ? "New Favorite \(favorites.count + 1)" : favoriteName
        let newFavorite = FavoriteItem(name: name, recipes: selectedRecipes)
        context.insert(newFavorite)
        dismiss()
    }
}

struct RecipeSelectionSheet: View {
    @Query private var recipes: [Recipe]
    @Binding var selectedRecipes: [Recipe]
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var selection = Set<UUID>()
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        }
        return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                
                List(filteredRecipes, id: \.id, selection: $selection) { recipe in
                    Text(recipe.name)
                        .tag(recipe.id)
                }
                .listStyle(.plain)
                
                Text("\(selection.count) selected")
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
            }
            .navigationTitle("Select Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add Selected") {
                    for recipe in filteredRecipes where selection.contains(recipe.id) {
                        if !selectedRecipes.contains(where: { $0.id == recipe.id }) {
                            selectedRecipes.append(recipe)
                        }
                    }
                    isPresented = false
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search recipes", text: $searchText)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}


