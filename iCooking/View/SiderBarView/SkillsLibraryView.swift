import SwiftUI
import SwiftData

struct SkillsLibraryView: View {
    var columns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Array(repeating: GridItem(.flexible()), count: 2)
        } else {
            return [GridItem(.flexible())]
        }
    }
    
    @Query(sort: \Skill.name) var skills: [Skill]
    @Environment(\.modelContext) private var context
    
    @State private var searchText: String = ""
    @State private var showAddSkill: Bool = false
    
    @State private var selectedModelFileName: String = ""
    @State private var toggleARQuickLookView: Bool = false

    var filteredSkills: [Skill] {
        if searchText.isEmpty {
            return skills
        } else {
            return skills.filter { skill in
                skill.name.localizedCaseInsensitiveContains(searchText) ||
                skill.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredSkills) { skill in
                    SkillViewComponent(skill: skill)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .contextMenu {
                            
                            if skill.ARFileName != nil {
                                Button{
                                    toggleARQuickLookView = true
                                } label:{
                                    Label("AR View", systemImage: "arkit")
                                }
                            }
                            
                            Button(role: .destructive) {
                                deleteSkill(skill)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                Button(action: {
                    showAddSkill.toggle()
                }) {
                    AddButton()
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Skills Library")
        .searchable(text: $searchText)
        .sheet(isPresented: $showAddSkill) {
            AddSkillView(isPresented: $showAddSkill)
        }
        .fullScreenCover(isPresented: $toggleARQuickLookView){
            ZStack{
                QLModel(name: selectedModelFileName)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Button {
                        toggleARQuickLookView=false
                    } label: {
                        HStack{
                            Label("Back", systemImage: "chevron.backward.circle")
                                .font(.largeTitle)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    private func deleteSkill(_ skill: Skill) {
        context.delete(skill)
        do {
            try context.save()
        } catch {
            print("Error deleting ingredient: \(error)")
        }
    }
}

struct SkillViewComponent: View {
    @Environment(\.colorScheme) var colorScheme
    var skill: Skill
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(skill.name)
                        .font(.title2)
                        .bold()
                    Text(skill.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: skill.icon)
                    .imageScale(.large)
                    .foregroundStyle(.blue)
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

struct AddSkillView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    @State private var skillName: String = ""
    @State private var category: String = "General"
    @State private var showAlert = false
    
    let categories = ["General", "Cutting", "Cooking", "Baking", "Preparation"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Skill Details") {
                    TextField("Skill Name", text: $skillName)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("New Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSkill()
                    }
                    .disabled(skillName.isEmpty)
                }
            }
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a skill name")
            }
        }
    }
    
    private func saveSkill() {
        guard !skillName.isEmpty else {
            showAlert = true
            return
        }
        
        let newSkill = Skill(name: skillName, category: category)
        context.insert(newSkill)
        dismiss()
    }
}

