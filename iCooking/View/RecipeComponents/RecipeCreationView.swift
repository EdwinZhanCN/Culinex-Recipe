import SwiftUI
import SwiftData

struct RecipeCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // Recipe properties
    @State private var recipeName: String = ""
    @State private var steps: [RecipeStep] = []
    @State private var selectedIngredients: [Ingredient] = []
    
    // Step creation properties
    @State private var isCreatingStep: Bool = false
    @State private var selectedTab: Int = 0
    @State private var description: String = ""
    @State private var skills: [Skill] = []
    @State private var stepIngredients: [Ingredient] = []
    @State private var durationValue: Double = 0.0
    @State private var durationUnit: String = "min"
    
    // Data from SwiftData
    @Query var ingredients: [Ingredient]
    
    var body: some View {
        HStack(spacing: 10) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(steps) { step in
                        stepBlockView(recipeStep: step)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.quaternary)
                            )
                    }
                    
                    if isCreatingStep {
                        stepBlockEditingView(
                            discription: $description,
                            skills: $skills,
                            ingredients: $stepIngredients,
                            durationValue: $durationValue,
                            durationUnit: $durationUnit
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.quaternary)
                        )
                        .onDrop(of: [.text], isTargeted: nil) { providers in
                            handleIngredientDrop(providers)
                            return true
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            VStack {
                if isCreatingStep {
                    NewStepTabs(
                        isCreatingNewStep: $isCreatingStep,
                        selectedTab: $selectedTab
                    )
                } else {
                    Button {
                        isCreatingStep.toggle()
                    } label: {
                        Text("Create a new step")
                            .font(.title3)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Divider()
                
                TabView(selection: $selectedTab) {
                    ExistingStepTabs()
                        .tag(0)
                    ExisitingIngredientView(selectedIngredients: $stepIngredients)
                        .tag(1)
                    Text("Skills")
                        .tag(2)
                    Text("Timer")
                        .tag(3)
                    Text("Tags")
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("New Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                TextField("Recipe Name", text: $recipeName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveRecipe()
                }
                .disabled(recipeName.isEmpty)
            }
        }
    }
    
    private func handleIngredientDrop(_ providers: [NSItemProvider]) {
        providers.first?.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data,
               let idString = String(data: data, encoding: .utf8),
               let uuid = UUID(uuidString: idString),
               let ingredient = ingredients.first(where: { $0.id == uuid }) {
                DispatchQueue.main.async {
                    if !stepIngredients.contains(where: { $0.id == ingredient.id }) {
                        stepIngredients.append(ingredient)
                    }
                }
            }
        }
    }
    
    private func saveRecipe() {
        let newRecipe = Recipe(
            name: recipeName,
            ingredients: selectedIngredients,
            steps: steps
        )
        context.insert(newRecipe)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        RecipeCreationView()
            .modelContainer(previewContainer)
    }
}
