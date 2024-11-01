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
    
    @Query(sort:\Skill.name) var skills: [Skill]
    @State private var searchText: String = ""
    @State private var showAddSkill: Bool = false
    
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
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredSkills) { skill in
                    SkillViewComponent(skill: skill)
                        .padding()
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
    }
}

struct SkillViewComponent: View {
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
                Image(systemName: "scissors")
                    .imageScale(.large)
                    .foregroundStyle(.blue)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
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

#Preview {
    SkillsLibraryView()
        .modelContainer(previewContainer)
} 
