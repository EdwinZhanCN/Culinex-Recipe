import SwiftUI
import SwiftData
import PhotosUI

/// The IngredientsView takes the array of ingredients from viewmodel and pass it to the smaller components
struct MyIngredientsView: View{
    
    // Define the columns for the grid view based on the device
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
    
    
    // Query data from the sqlite database
    @Query(sort:\Ingredient.name) var ingredients:[Ingredient]
    
    
    // filter the ingredients based on the search text
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
    @State private var isRefreshing = false
    
    // The model context to save the data
    @Environment(\.modelContext) private var context
    
    var body: some View{
        Group {
            if ingredients.isEmpty {
                // Empty view
                ContentUnavailableView(
                    "No Ingredients",
                    systemImage: "fork.knife",
                    description: Text("Add first ingredient to get started.")
                )
            } else {
                // Normal View
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(filteredIngredients){ ingredient in
                            IngredientViewComponent(ingredient: ingredient)
                                .contentShape(RoundedRectangle(cornerRadius: 8))
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
                .refreshable {
                    isRefreshing = true
                }
                .sheet(isPresented: $showAddIngredient, content: {
                    AddIngredientView(
                        isPresented: $showAddIngredient
                    )
                })
                
            }
        }
    }
    
    private func deleteIngredient(_ ingredient: Ingredient) {
        let generator = UINotificationFeedbackGenerator()
        context.delete(ingredient)
        do {
            try context.save()
            generator.notificationOccurred(.success)
        } catch {
            generator.notificationOccurred(.error)
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
                if let imageData = ingredient.image {
                    if let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage) // Using system image
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                    }
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
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceSelection = false

    var body: some View {
        NavigationView {
            Form {
                Section("Ingredient Details") {
                    TextField("Name of ingredient", text: $ingredientName)
                }

                Section("Ingredient Image") {
                    Button(action: {
                        showSourceSelection = true
                    }) {
                        Label("Add Image", systemImage: "photo.on.rectangle")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .confirmationDialog("Select Image Source", isPresented: $showSourceSelection) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            Button("Take Photo") {
                                imagePickerSourceType = .camera
                                showImagePicker = true
                            }
                        }
                        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                            Button("Choose from Library") {
                                imagePickerSourceType = .photoLibrary
                                showImagePicker = true
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }

                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(UIColor.systemGray3))

                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(16)
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

        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            newIngredient.image = imageData
        }

        context.insert(newIngredient)
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving ingredient: \(error)")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Delegate method when an image is selected
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.selectedImage = uiImage
            } else if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        // Delegate method when the picker is canceled
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Create the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true // Enable editing
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    MyIngredientsView()
        .modelContainer(previewContainer)
}
