import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // MARK: - Recipe Data
    var recipe: Recipe
    
    // MARK: - State Properties
    @State private var isEditingName: Bool = false
    @State private var isNewRecipe: Bool
    
    // Recipe Properties
    @State private var recipeName: String
    @State private var recipeSteps: [RecipeStep]
    
    // MARK: - UI State
    @State private var isCreatingStep: Bool = false
    @State private var selectedTab: Int = 0
    @State private var isInFullScreen: Bool = false
    
    // MARK: - New Step Properties
    @State private var newStepDescription: String = ""
    @State private var newStepSkills: [Skill] = []
    @State private var newStepIngredients: [Ingredient] = []
    @State private var newStepDurationValue: Double = 0.0
    @State private var newStepDurationUnit: UnitOfTime = .min
    @State private var newStepTools: [String] = []
    
    // MARK: - SwiftData Queries
    @Query var contextIngredients: [Ingredient]
    @Query var contextSteps: [RecipeStep]
    
    // MARK: - Initialization
    init(recipe: Recipe, isNewRecipe: Bool) {
        self.recipe = recipe
        
        // Initialize State variables
        self._recipeName = State(initialValue: recipe.name)
        self._recipeSteps = State(initialValue: recipe.steps)
        self._isNewRecipe = State(initialValue: isNewRecipe)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // MARK: - Steps Content Area
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Welcome messages and empty state
                        contentHeaderView
                        
                        // Existing recipe steps
                        stepsListView
                        
                        // New step in editing mode
                        if isCreatingStep {
                            newStepEditingView
                        }
                    }
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color(uiColor: .systemBackground))
                
                // MARK: - Sidebar
                sidebar
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isInFullScreen){
            StepFullScreenView(steps: $recipeSteps)
                .interactiveDismissDisabled()
        }
        .toolbar {
            toolbarContent
        }
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var contentHeaderView: some View {
        Group {
            if recipeSteps.isEmpty && !isCreatingStep {
                EmptyStateView(message: "No steps yet. Create your first step!")
            }
            
            if isNewRecipe {
                Text("Welcome to your new recipe!")
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.gradient)
                    )
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private var stepsListView: some View {
        ForEach(recipeSteps.indices, id: \.self) { index in
            stepBlockView(
                recipeStep: recipeSteps[index],
                isInFullScreen: $isInFullScreen
            )
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(alignment: .topLeading) {
                Text("Step \(index + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(6)
                    .background(
                        Capsule()
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 1)
                    )
                    .offset(x: 10, y: -10)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    @ViewBuilder
    private var newStepEditingView: some View {
        stepBlockEditingView(
            discription: $newStepDescription,
            skills: $newStepSkills,
            ingredients: $newStepIngredients,
            durationValue: $newStepDurationValue,
            durationUnit: $newStepDurationUnit
        )
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6)
                    .gradient
                    .opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(alignment: .topLeading) {
            Text("New Step")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(6)
                .background(
                    Capsule()
                        .fill(.thinMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 1)
                )
                .offset(x: 10, y: -10)
        }
        .onDrop(of: [.text], isTargeted: nil) { providers in
            handleIngredientDrop(providers)
            return true
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    @ViewBuilder
    private var sidebar: some View {
        VStack(spacing: 16) {
            // Sidebar Header - Step Creation or Add Button
            sidebarHeader
            
            Divider()
                .padding(.horizontal)
            
            // Tab Content
            TabView(selection: $selectedTab) {
                ExistingStepTabs()
                    .tag(0)
                if isCreatingStep {
                    ExisitingIngredientView(selectedIngredients: $newStepIngredients)
                        .tag(1)
                    DescriptionView(discription: $newStepDescription, tools: $newStepTools)
                        .tag(2)
                    TimerSettingView(durationValue: $newStepDurationValue, durationUnit: $newStepDurationUnit)
                        .tag(3)
                    SkillSelectionView(selectedSkills: $newStepSkills)
                        .tag(4)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
        .frame(width: 400)
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    @ViewBuilder
    private var sidebarHeader: some View {
        if isCreatingStep {
            NewStepTabs(
                isCreatingNewStep: $isCreatingStep,
                selectedTab: $selectedTab,
                stepIngredients: $newStepIngredients,
                skills: $newStepSkills,
                description: $newStepDescription,
                durationValue: $newStepDurationValue,
                durationUnit: $newStepDurationUnit,
                tools: $newStepTools,
                isNewRecipe: $isNewRecipe,
                createNewStep: createNewStep,
                saveRecipe: saveRecipe
            )
        } else {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isCreatingStep.toggle()
                }
            } label: {
                Label("Create a new step", systemImage: "plus.circle.fill")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if isEditingName || isNewRecipe {
            editModeToolbarItems
        } else {
            viewModeToolbarItems
        }
    }
    
    @ToolbarContentBuilder
    private var editModeToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Cancel") {
                if recipe.name.isEmpty {
                    recipeName = ""
                } else {
                    isEditingName = false
                    // Reset changes
                    recipeName = recipe.name
                }
            }
            .buttonStyle(.bordered)
            .tint(.secondary)
        }
        
        ToolbarItem(placement: .principal) {
            TextField("Recipe Name", text: $recipeName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 250)
                .multilineTextAlignment(.center)
                .font(.headline)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button("Save") {
                withAnimation {
                    saveRecipe()
                    isEditingName = false
                    isNewRecipe = false
                }
            }
            .disabled(recipeName.isEmpty || recipeSteps.isEmpty)
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ToolbarContentBuilder
    private var viewModeToolbarItems: some ToolbarContent {
        // Recipe name display
        ToolbarItem(placement: .principal) {
            Text(recipeName)
                .font(.headline)
                .bold()
        }
        
        // Edit name button
        ToolbarItem(placement: .topBarLeading) {
            Button {
                isEditingName = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(.borderless)
        }
        
        // Start recipe button
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isInFullScreen = true
            } label: {
                Label("Start Recipe", systemImage: "arrowtriangle.forward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.green)
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleIngredientDrop(_ providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                if let data = data as? Data, let idString = String(data: data, encoding: .utf8), let uuid = UUID(uuidString: idString) {
                    if let ingredient = contextIngredients.first(where: { $0.id == uuid }) {
                        newStepIngredients.append(ingredient)
                    }
                }
            }
        }
    }
    
    private func createNewStep() {
        let newStep = RecipeStep(
            ingredients: newStepIngredients,
            description: newStepDescription,
            skills: newStepSkills,
            tools: newStepTools,
            duration: StepTime(value: newStepDurationValue, unit: newStepDurationUnit)
        )
        
        recipeSteps.append(newStep)
        
        // Reset all step creation properties
        newStepDescription = ""
        newStepSkills = []
        newStepIngredients = []
        newStepDurationValue = 0.0
        newStepDurationUnit = .min
        newStepTools = []
        isCreatingStep = false
        selectedTab = 0
    }
    
    private func saveRecipe() {
        recipe.name = recipeName
        recipe.steps = recipeSteps
        
        if isNewRecipe {
            context.insert(recipe)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}

// MARK: - Supporting Views

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
                .symbolEffect(.pulse)
            
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
    }
}

struct ExistingStepTabs: View {
    @Query(sort: \RecipeStep.descrip) var existingSteps: [RecipeStep]
    
    let columns = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(existingSteps) { step in
                    Text(step.descrip)
                        .lineLimit(2)
                        .font(.system(.subheadline, design: .rounded))
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.tertiary)
                        )
                        .contextMenu {
                            Button("Copy Description", systemImage: "doc.on.doc") {
                                UIPasteboard.general.string = step.descrip
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct NewStepTabs: View {
    @Binding var isCreatingNewStep: Bool
    @Binding var selectedTab: Int
    @Binding var stepIngredients: [Ingredient]
    @Binding var skills: [Skill]
    @Binding var description: String
    @Binding var durationValue: Double
    @Binding var durationUnit: UnitOfTime
    @Binding var tools: [String]
    @Binding var isNewRecipe: Bool
    var createNewStep: () -> Void
    var saveRecipe: () -> Void

    @State private var showAlert = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Action Buttons
            HStack {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        description = ""
                        skills = []
                        stepIngredients = []
                        durationValue = 0.0
                        durationUnit = .min
                        isCreatingNewStep = false
                        selectedTab = 0
                        tools = []
                    }
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                .tint(.secondary)
                
                Spacer()
                
                Button {
                    if !(
                        description.isEmpty
                        || skills.isEmpty
                        || stepIngredients.isEmpty
                        || durationValue.isZero
                        || durationUnit.rawValue.isEmpty
                        || tools.isEmpty
                    ) {
                        withAnimation {
                            createNewStep()
                        }
                        if !isNewRecipe {
                            saveRecipe()
                        }
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Save Step")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .disabled(description.isEmpty)
            }
            .padding(.horizontal, 20)
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
            
            // Tab Selection Buttons
            LazyVGrid(columns: columns, spacing: 12) {
                TabButton(
                    title: "Ingredients",
                    icon: "carrot",
                    isCompleted: !stepIngredients.isEmpty,
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
                
                TabButton(
                    title: "Description",
                    icon: "pencil.line",
                    isCompleted: !(description.isEmpty && tools.isEmpty),
                    isSelected: selectedTab == 2,
                    action: { selectedTab = 2 }
                )
                
                TabButton(
                    title: "Timer",
                    icon: "timer",
                    isCompleted: !durationValue.isZero,
                    isSelected: selectedTab == 3,
                    action: { selectedTab = 3 }
                )
                
                TabButton(
                    title: "Skills",
                    icon: "tag",
                    isCompleted: !skills.isEmpty,
                    isSelected: selectedTab == 4,
                    action: { selectedTab = 4 }
                )
            }
            .padding(.horizontal, 12)
        }
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isCompleted: Bool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(isSelected ? .primary : .secondary)
                        .symbolEffect(.bounce, value: isSelected)
                }
                .overlay(alignment: .topTrailing) {
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.white, .green)
                            .background(Circle().fill(.white).shadow(radius: 1))
                            .offset(x: 4, y: -4)
                    }
                }
                
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(.secondarySystemBackground) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
