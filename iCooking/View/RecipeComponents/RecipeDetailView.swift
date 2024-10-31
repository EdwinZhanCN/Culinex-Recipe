import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    var recipe: Recipe

    //form data to create the new step
    @State var discription: String = ""
    @State var skills:[String] = []
    @State var ingredients:[Ingredient] = []
    @State var durationValue:Double = 0.0
    @State var durationUnit:String = "min"
    
    
    @State var isCreatingStep: Bool = false
    @State var selectedTab: Int = 0
    
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
                            ingredients: $ingredients,
                            durationValue: $durationValue,
                            durationUnit: $durationUnit
                        )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(UIColor.systemGray6))
                            )
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
                    Text("Detail for Tab 1")
                        .tag(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text("Detail for Tab 2")
                        .tag(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Text("Detail for Tab 3")
                        .tag(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text("Detail for Tab 4")
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

struct stepBlockView:View{
    var recipeStep: RecipeStep
    var body: some View{
        VStack(alignment:.leading){
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
            HStack{
                // display the custom skills, and skills extracted from the description
                VStack(alignment: .leading){
                    ScrollView{
                        HStack{
                            ForEach(recipeStep.skills, id:\.self){skill in
                                Text(skill)
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
    @Binding var skills:[String]
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
                                ForEach(skills, id:\.self){skill in
                                    Text(skill)
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


#Preview {
    RecipeDetailView(
        recipe: sampleRecipes.first!
    )
    .modelContainer(previewContainer)
}
