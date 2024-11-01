import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    var recipe: Recipe

    //form data to create the new step
    @State var discription: String = ""
    @State var skills:[Skill] = []
    @State var selectedIngredients:[Ingredient] = []
    @State var durationValue:Double = 0.0
    @State var durationUnit:String = "min"
    
    
    @State var isCreatingStep: Bool = false
    @State var selectedTab: Int = 0
    
    //data from swift data
    @Query var ingredients:[Ingredient]
    
    var body: some View {
        HStack(spacing:10){
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(recipe.steps) { step in
                        stepBlockView(recipeStep: step)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(UIColor.systemGray6))
                            )
                    }
                    if isCreatingStep{
                        stepBlockEditingView(
                            discription: $discription,
                            skills: $skills,
                            ingredients: $selectedIngredients,
                            durationValue: $durationValue,
                            durationUnit: $durationUnit
                        )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(UIColor.systemGray6))
                            )
                            .onDrop(of: [.text], isTargeted: nil) { providers in
                                providers.first?.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                                    if let data = data as? Data, let idString = String(data: data, encoding: .utf8),
                                       let uuid = UUID(uuidString: idString),
                                       let ingredient = ingredients.first(where: { $0.id == uuid }) {
                                        DispatchQueue.main.async {
                                            if !selectedIngredients.contains(where: { $0.id == ingredient.id }) {
                                                selectedIngredients.append(ingredient)
                                            }
                                        }
                                    }
                                }
                                return true
                            }
                    }
                }
            }
            .padding(.horizontal)
            VStack{
                if isCreatingStep{
                    NewStepTabs(
                        isCreatingNewStep: $isCreatingStep,
                        selectedTab: $selectedTab
                    )
                }else{
                    Button{
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    ExisitingIngredientView(selectedIngredients: $selectedIngredients)
                        .tag(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    DescriptionView(discription: $discription)
                        .tag(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    TimerSettingView(durationValue: $durationValue, durationUnit: $durationUnit)
                        .tag(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    SkillSelectionView(selectedSkills: $skills)
                        .tag(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
            .frame(maxWidth: 400)
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity)
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
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View{
        VStack{
            HStack{
                Button{
                    isCreatingNewStep.toggle()
                    selectedTab = 0
                }label: {
                    Text("Cancle")
                }
                .buttonStyle(.bordered)
                Spacer()
                Button{
                    isCreatingNewStep.toggle()
                }label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal,20)
            LazyVGrid(columns: columns,spacing: 10){
                Button{
                    selectedTab = 1
                }label: {
                    HStack{
                        Label("Ingredients",systemImage: "carrot")
                            .symbolEffect(.pulse)
                            .imageScale(.large)
                            .foregroundStyle(.indigo,.red)
                            .font(.title3)
                            .padding(10)
                    }
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tertiary)
                    )
                }
                
                Button{
                    selectedTab = 2
                }label: {
                    HStack{
                        Label("Description",systemImage: "pencil.line")
                            .symbolEffect(.pulse)
                            .imageScale(.large)
                            .foregroundStyle(.indigo,.red)
                            .symbolRenderingMode(.palette)
                            .font(.title3)
                            .padding(10)
                    }
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tertiary)
                    )
                }
                
                Button{
                    selectedTab = 3
                }label: {
                    HStack{
                        Label("Timer",systemImage: "timer")
                            .symbolEffect(.pulse)
                            .imageScale(.large)
                            .foregroundStyle(.indigo,.red)
                            .symbolRenderingMode(.palette)
                            .font(.title3)
                            .padding(10)
                    }
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.quaternary)
                    )
                }
                
                Button{
                    selectedTab = 4
                }label: {
                    HStack{
                        Label("Tags",systemImage: "tag")
                            .symbolEffect(.pulse)
                            .imageScale(.large)
                            .foregroundStyle(.indigo)
                            .symbolRenderingMode(.palette)
                            .font(.title3)
                            .padding(10)
                    }
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tertiary)
                    )
                }
            }
        }
        
    }
}

struct stepBlockView: View {
    var recipeStep: RecipeStep
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipeStep.descrip)
                .foregroundStyle(.white)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.tertiary)
                        .opacity(0.8)
                )
                .padding(.vertical, 10)
                .padding(.horizontal,5)
            HStack {
                VStack(alignment: .leading) {
                    if !recipeStep.skills.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recipeStep.skills) { skill in
                                    HStack {
                                        Text(skill.name)
                                        Text(skill.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .foregroundStyle(.orange.opacity(0.5))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
                    ScrollView{
                        HStack{
                            ForEach(recipeStep.ingredients){ingredient in
                                Text(ingredient.name)
                                    .padding(5)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .foregroundStyle(.link)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
                
                //duration
                VStack{
                    let durationValue = recipeStep.durationValue.isNaN ? 0 : recipeStep.durationValue
                    let durationString:String = {
                        if durationValue > 1 {
                            return (
                                "\(String(format: "%.1f", durationValue)) \(recipeStep.durationUnit)s"
                            )
                        }
                        return "\(String(format: "%.1f", durationValue)) \(recipeStep.durationUnit)"
                    }()
                    Spacer()
                    Label(
                        "\(durationString)",
                        systemImage: "timer"
                    )
                        .font(.title3)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.tertiary)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct stepBlockEditingView:View{
    @Binding var discription: String
    @Binding var skills:[Skill]
    @Binding var ingredients:[Ingredient]
    @Binding var durationValue:Double
    @Binding var durationUnit:String
    var body: some View{
        VStack(alignment:.leading){
            //display the discription
            if !discription.isEmpty{
                Text(discription)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.tertiary)
                            .opacity(0.8)

                            
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal,5)
            } else{
                Text("Use tools on the right to create a new Step!")
                    .font(.title)
            }
            HStack{
                // display the custom skills, and skills extracted from the description
                VStack(alignment: .leading){
                    if !skills.isEmpty{
                        ScrollView{
                            HStack{
                                ForEach(skills){skill in
                                    Text(skill.name)
                                        .padding(5)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .foregroundStyle(.orange)
                                                .opacity(0.5)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    if !ingredients.isEmpty{
                        ScrollView{
                            HStack{
                                ForEach(ingredients){ingredient in
                                    Text(ingredient.name)
                                        .padding(5)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .foregroundStyle(.link)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
                
                //duration
                VStack{
                    let durationValue = durationValue.isNaN ? 0 : durationValue
                    let durationString:String = {
                        if durationValue > 1 {
                            return (
                                "\(String(format: "%.1f", durationValue)) \(durationUnit)s"
                            )
                        }
                        return "\(String(format: "%.1f", durationValue)) \(durationUnit)"
                    }()
                    Spacer()
                    Label(
                        "\(durationString)",
                        systemImage: "timer"
                    )
                        .font(.title3)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.tertiary)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct ExisitingIngredientView: View {
    @Query var ingredients: [Ingredient]
    @Binding var selectedIngredients: [Ingredient]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(ingredients) { ingredient in
                    HStack {
                        if let image = ingredient.image {
                            Image(image)
                                .resizable()
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text(ingredient.name)
                            .font(.title3)
                        
                        Spacer()
                        
                        // Selection indicator
                        if selectedIngredients.contains(where: { $0.id == ingredient.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedIngredients.contains(where: { $0.id == ingredient.id }) 
                                ? Color.green 
                                : Color(uiColor: .systemGray5),
                                lineWidth: 4
                            )
                            .background(
                                Color(UIColor.systemGray6).cornerRadius(8)
                            )
                    )
                    .onTapGesture {
                        if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                            selectedIngredients.remove(at: index)
                        } else {
                            selectedIngredients.append(ingredient)
                        }
                    }
                    .onDrag {
                        NSItemProvider(object: ingredient.id.uuidString as NSString)
                    }
                    .padding(.horizontal)
                    .padding(.top,10)
                }
            }
        }
    }
}

struct DescriptionView: View {
    @Binding var discription: String
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            Text("Description")
                .font(.title2)
                .padding(.horizontal,20)
                .padding(.top)
            TextField("Description", text: $discription, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5...10)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

struct TimerSettingView: View {
    @Binding var durationValue: Double
    @Binding var durationUnit: String
    
    let timeUnits = ["sec", "min", "hr"]
    let commonDurations = [5.0, 15.0, 30.0, 60.0]
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Set Duration")
                .font(.title2)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                // Common durations
                VStack(alignment: .leading) {
                    Text("Quick Select")
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 10) {
                        ForEach(commonDurations, id: \.self) { value in
                            Button {
                                durationValue = value
                            } label: {
                                Text("\(Int(value))")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(durationValue == value ? Color.accentColor : Color(UIColor.systemGray5))
                                    )
                                    .foregroundStyle(durationValue == value ? .white : .primary)
                            }
                        }
                    }
                }
                
                // Custom duration input
                VStack(alignment: .leading) {
                    Text("Custom Duration")
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        TextField("Value", value: $durationValue, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        
                        Button {
                            isShowingPicker.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .imageScale(.large)
                        }
                    }
                    
                    if isShowingPicker {
                        Slider(
                            value: $durationValue,
                            in: 0...60,
                            step: 0.5
                        ) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("60")
                        }
                        .padding(.vertical)
                    }
                }
                
                // Time unit selection
                VStack(alignment: .leading) {
                    Text("Unit")
                        .foregroundStyle(.secondary)
                    
                    Picker("Time Unit", selection: $durationUnit) {
                        ForEach(timeUnits, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            // Preview of the set time
            if durationValue > 0 {
                Label(
                    "\(String(format: "%.1f", durationValue)) \(durationUnit)\(durationValue > 1 ? "s" : "")",
                    systemImage: "timer"
                )
                .font(.title3)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.tertiary)
                )
            }
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: isShowingPicker)
    }
}

// Add this new view component
struct SkillSelectionView: View {
    @Query var skills: [Skill]
    @Binding var selectedSkills: [Skill]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(skills) { skill in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.title3)
                            Text(skill.category)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // Selection indicator
                        if selectedSkills.contains(where: { $0.id == skill.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedSkills.contains(where: { $0.id == skill.id }) 
                                ? Color.green 
                                : Color(.systemGray5),
                                lineWidth: 2
                            )
                            .background(Color(.systemGray6))
                    )
                    .onTapGesture {
                        if let index = selectedSkills.firstIndex(where: { $0.id == skill.id }) {
                            selectedSkills.remove(at: index)
                        } else {
                            selectedSkills.append(skill)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}




#Preview {
    RecipeDetailView(
        recipe: sampleRecipes.first!
    )
    .modelContainer(previewContainer)
}
