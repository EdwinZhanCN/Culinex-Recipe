import SwiftUI
import SwiftData
import PhotosUI

/// The IngredientsView takes the array of ingredients from viewmodel and pass it to the smaller components
struct MyIngredientsView: View{
    
    var columns: [GridItem] {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Array(repeating: GridItem(.flexible()), count: 2)
        } else {
            return [GridItem(.flexible())]
        }
        #else
        return Array(repeating: GridItem(.flexible()), count: 2) // default
        #endif
    }
    
    @Query(sort:\Ingredient.name) var ingredients:[Ingredient]
    
    @State private var searchText: String = ""
    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { ingredient in
                ingredient.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    @State private var showAddIngredient: Bool = false
    @State private var selectedIngredient: Ingredient?
    @Environment(\.modelContext) private var context
    
    var body: some View{
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(filteredIngredients){ ingredient in
                    IngredientViewComponent(ingredient: ingredient)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(role: .destructive){
                                deleteIngredient(ingredient)
                            } label:{
                                Label("Delete", systemImage: "trash")
                            }
                            
                        }
                }
                Button(action: {
                    showAddIngredient.toggle()
                }){
                    AddButton()
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Ingredients Library")
        .searchable(text: $searchText)
        .sheet(isPresented: $showAddIngredient, content: {
            AddIngredientView(
                isPresented: $showAddIngredient
            )
        })
    }
    
    private func deleteIngredient(_ ingredient: Ingredient) {
        context.delete(ingredient)
        do {
            try context.save()
        } catch {
            print("Error deleting ingredient: \(error)")
        }
    }
}

struct IngredientViewComponent: View{
    @Environment(\.colorScheme) var colorScheme
    var ingredient: Ingredient
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(ingredient.name)
                        .font(.title2)
                        .bold()
                }
                Spacer()
                if let image = ingredient.image {
                    Image(image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                } else {
                    // Deal with no image
                    Image(systemName: "photo") // Using system image
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                }
                
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color(
                        colorScheme == .dark ? UIColor.systemGray5 : UIColor.systemGray6
                    )
                )
                .shadow(radius: 2)
        )
    }
}

struct AddButton: View{
    var body: some View{
        Image(systemName: "plus")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .padding(20)
            .background(
                Circle()
                    .fill(Color.blue)
                    .shadow(radius: 2)
            )
    }
}

struct AddIngredientView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    @State private var ingredientName: String = ""
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Ingredient Details") {
                    TextField("Name of ingredient", text: $ingredientName)
                }
                
                Section("Ingredient Image"){
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
                        Label("Choose from Library", systemImage: "photo.on.rectangle")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .onChange(of: selectedImageItem) { oldValue, newValue in
                        if newValue != oldValue {
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                            .frame(width:200, height: 200)
                            .foregroundColor(Color(UIColor.systemGray3))
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()

                        }
                    }
                }
            }
            .navigationTitle("New Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIngredient()
                    }
                    .disabled(ingredientName.isEmpty)
                }
            }
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter an ingredient name")
            }
        }
    }
    
    private func saveIngredient() {
        guard !ingredientName.isEmpty else {
            showAlert = true
            return
        }
        
        let newIngredient = Ingredient(name: ingredientName)
        context.insert(newIngredient)
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving ingredient: \(error)")
        }
    }
}


#Preview {
    MyIngredientsView()
        .modelContainer(previewContainer)
}
