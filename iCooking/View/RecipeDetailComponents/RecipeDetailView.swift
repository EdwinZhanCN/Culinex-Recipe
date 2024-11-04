import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // Passed in Recipe
    var PassedInRecipe: Recipe
    
    // Conditional Properties
    @State private var isEditingName: Bool = false
    @State private var isNewRecipe: Bool
    
    // Recipe Properties
    @State private var PassedInName: String // passed in
    @State private var PassedInSteps: [RecipeStep] // passed in
    
    // Creation Properties
    @State private var isCreatingStep: Bool = false
    @State private var selectedTab: Int = 0
    
    // Step properties
    @State private var NewStepDiscription: String = ""
    @State private var NewStepSkills: [Skill] = []
    @State private var NewStepIngredients: [Ingredient] = []
    @State private var NewStepDurationValue: Double = 0.0
    @State private var NewStepDurationUnit: UnitOfTime = .min
    @State private var NewStepTools:[String] = []
    
    
    // Data from SwiftData
    @Query var contextIngredients: [Ingredient]
    @Query var contextSteps: [RecipeStep]
    
    init(recipe: Recipe, isNewRecipe: Bool) {
        self.PassedInRecipe = recipe
        
        // Extract
        self._PassedInName = State(initialValue: recipe.name)
        self._PassedInSteps = State(initialValue: recipe.steps)
        
        // Condition
        self.isNewRecipe = isNewRecipe
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Step Blocks
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Msg
                        if PassedInSteps.isEmpty && !isCreatingStep {
                            Text("No steps yet. Create your first step!")
                                .foregroundStyle(.secondary)
                                .padding()
                        }
                        if isNewRecipe{
                            Text("Welcome to your new recipe!")
                                .padding()
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.gray)
                                )
                                .padding(.horizontal)
                        }
                        
                        // Iterate the steps of passed in recipe
                        ForEach(PassedInSteps) { step in
                            
                            stepBlockView(recipeStep: step)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color(UIColor.systemGray6))
                                )
                            
                        }
                        
                        // A New Step, but is editing
                        if isCreatingStep {
                            
                            // the parameter for display usage
                            stepBlockEditingView(
                                discription: $NewStepDiscription,
                                skills: $NewStepSkills,
                                ingredients: $NewStepIngredients,
                                durationValue: $NewStepDurationValue,
                                durationUnit: $NewStepDurationUnit
                            )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(UIColor.systemGray6))
                            )
                            .onDrop(of: [.text], isTargeted: nil) { providers in
                                handleIngredientDrop(providers)
                                return true
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                // SideBar, Buttons
                VStack {
                    // Appears if Button pressed
                    if isCreatingStep {
                        NewStepTabs(
                            isCreatingNewStep: $isCreatingStep,
                            selectedTab: $selectedTab,
                            stepIngredients: $NewStepIngredients,
                            skills: $NewStepSkills,
                            description: $NewStepDiscription,
                            durationValue: $NewStepDurationValue,
                            durationUnit: $NewStepDurationUnit,
                            tools: $NewStepTools,
                            isNewRecipe: $isNewRecipe,
                            createNewStep: createNewStep,
                            saveRecipe: saveRecipe
                        )
                    } else {
                        // Suggestion Button
                        Button {
                            isCreatingStep.toggle()
                        } label: {
                            Text("Create a new step")
                                .font(.title3)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    
                    Divider()
                    
                    TabView(selection: $selectedTab) {
                        ExistingStepTabs()
                            .tag(0)
                        if isCreatingStep{
                            ExisitingIngredientView(selectedIngredients: $NewStepIngredients)
                                .tag(1)
                            DescriptionView(discription: $NewStepDiscription, tools: $NewStepTools)
                                .tag(2)
                            TimerSettingView(durationValue: $NewStepDurationValue, durationUnit: $NewStepDurationUnit)
                                .tag(3)
                            SkillSelectionView(selectedSkills: $NewStepSkills)
                                .tag(4)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .frame(width: 400)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isEditingName || isNewRecipe {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        if PassedInRecipe.name.isEmpty {
                            PassedInName = ""
                        } else {
                            isEditingName = false
                            // Reset changes
                            PassedInName = PassedInRecipe.name
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    TextField("Recipe Name", text: $PassedInName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
                
                // Save button for all things
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // save all changes, conetxt save
                        saveRecipe()
                        isEditingName = false
                        isNewRecipe = false
                    }
                    .disabled(
                        PassedInName.isEmpty
                        || PassedInSteps.isEmpty
                    )
                    .buttonStyle(.borderedProminent)
                }
            } else {
                // Name
                ToolbarItem(placement: .topBarLeading) {
                    Text(PassedInName)
                        .padding(.leading,50)
                        .font(.headline)
                        .bold()
                }
                
                // Edit Name Button
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        isEditingName = true
                    }label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }
    
    private func printNewRecipeState(){
        print(isNewRecipe)
    }
    
    private func handleIngredientDrop(_ providers: [NSItemProvider]) {
        // handle the drop of ingredients
        for provider in providers {
            provider.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                if let data = data as? Data, let idString = String(data: data, encoding: .utf8), let uuid = UUID(uuidString: idString) {
                    if let ingredient = contextIngredients.first(where: { $0.id == uuid }) {
                        NewStepIngredients.append(ingredient)
                    }
                }
            }
        }
    }
    
    private func createNewStep() {
        // new step with schema
        let newStep = RecipeStep(
            ingredients: NewStepIngredients,
            description: NewStepDiscription,
            skills: NewStepSkills,
            tools: NewStepTools,
            duration: StepTime(value: NewStepDurationValue, unit: NewStepDurationUnit)
        )
        
        PassedInSteps.append(newStep)
        
        // Reset all step creation properties
        NewStepDiscription = ""
        NewStepSkills = []
        NewStepIngredients = []
        NewStepDurationValue = 0.0
        NewStepDurationUnit = .min
        NewStepTools = []
        isCreatingStep = false
        selectedTab = 0
    }
    
    private func saveRecipe() {
        PassedInRecipe.name = PassedInName
        PassedInRecipe.steps = PassedInSteps
        
        if isNewRecipe{
            context.insert(PassedInRecipe)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}

struct ExistingStepTabs:View{
    @Query(sort: \RecipeStep.descrip) var existingSteps: [RecipeStep]
    
    let columns = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]
    var body: some View{
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                ForEach(existingSteps){ step in
                    Text(step.descrip)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.tertiary)
                        )
                }
            }
        }
    }
}

struct NewStepTabs:View{
    @Binding var isCreatingNewStep:Bool
    @Binding var selectedTab:Int
    @Binding var stepIngredients:[Ingredient]
    @Binding var skills:[Skill]
    @Binding var description:String
    @Binding var durationValue:Double
    @Binding var durationUnit:UnitOfTime
    @Binding var tools:[String]
    @Binding var isNewRecipe:Bool
    var createNewStep: () -> Void
    var saveRecipe: () -> Void

    @State private var showAlert = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View{
        VStack{
            // Save Button
            HStack{
                Button{
                    description = ""
                    skills = []
                    stepIngredients = []
                    durationValue = 0.0
                    durationUnit = .min
                    isCreatingNewStep = false
                    selectedTab = 0
                    tools = []
                }label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button{
                    if !(
                        description.isEmpty
                        || skills.isEmpty
                        || stepIngredients.isEmpty
                        || durationValue.isZero
                        || durationUnit.rawValue.isEmpty
                        || tools.isEmpty
                    ) {
                        createNewStep()
                        if !isNewRecipe{
                            saveRecipe()
                        }
                    } else {
                        showAlert = true
                    }
                }label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
                .disabled(description.isEmpty)
            }
            .padding(.horizontal,20)
            .alert("Missing Information", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in all required fields:\n" +
                     (description.isEmpty ? "• Description\n" : "") +
                     (skills.isEmpty ? "• Skills\n" : "") +
                     (stepIngredients.isEmpty ? "• Ingredients\n" : "") +
                     (durationValue.isZero ? "• Duration\n" : "") +
                     (tools.isEmpty ? "• Tools" : ""))
            }
            
            // The TabViews
            LazyVGrid(columns: columns,spacing: 10){
                TabButton(
                    title: "Ingredients",
                    icon: "carrot",
                    isCompleted: !stepIngredients.isEmpty
                ) {
                    selectedTab = 1
                }
                
                TabButton(
                    title: "Description",
                    icon: "pencil.line",
                    isCompleted: !(description.isEmpty && tools.isEmpty)
                ) {
                    selectedTab = 2
                }
                
                TabButton(
                    title: "Timer",
                    icon: "timer",
                    isCompleted: !durationValue.isZero
                ) {
                    selectedTab = 3
                }
                
                TabButton(
                    title: "Tags",
                    icon: "tag",
                    isCompleted: !skills.isEmpty
                ) {
                    selectedTab = 4
                }
            }
        }
        
    }
}


struct TabButton: View {
    let title: String
    let icon: String
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isCompleted{
                    Label(title, systemImage: icon)
                        .imageScale(.large)
                        .foregroundStyle(isCompleted ? .indigo : .indigo)
                        .symbolRenderingMode(.palette)
                        .font(.title3)
                        .padding(10)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white)
                                .background(Circle().fill(.green))
                                .offset(x: 10, y: -5)
                        }
                } else{
                    Label(title, systemImage: icon)
                        .symbolEffect (.pulse)
                        .imageScale(.large)
                        .foregroundStyle(isCompleted ? .indigo : .indigo)
                        .symbolRenderingMode(.palette)
                        .font(.title3)
                        .padding(10)
                }
            }
            .foregroundStyle(.black)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.tertiary)
            )
        }
    }
}





