import SwiftUI
import SwiftData


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
    
    @Query var ingredients:[Ingredient]
    
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
    
    var body: some View{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 16){
                    ForEach(filteredIngredients){ ingredient in
                        IngredientViewComponent(Ingredient: ingredient)
                            .padding()
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                } label: {
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
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .navigationTitle("Ingredients Library")
            .searchable(text: $searchText)
            .sheet(isPresented: $showAddIngredient, content: {
                AddIngredientView(
                    isPresented: $showAddIngredient
                )
            })
    }
}


struct IngredientViewComponent: View{
    var Ingredient: Ingredient
    var body: some View{
            VStack {
                HStack{
                    if let image = Ingredient.image {
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
                    Text(Ingredient.name)
                        .font(.title)
                        .padding(.leading, 20)
                       
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 500)
            }
            .foregroundStyle(.primary)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .padding(-12)
                    .foregroundStyle(Color(UIColor.systemGray5))
            )
    }
}

struct AddButton: View{
    var body: some View{
            VStack {
                HStack{
                    Spacer()
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width:50, height:50)
                        .padding(10)
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 500)
            }
            .foregroundStyle(.primary)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .padding(-12)
                    .foregroundStyle(Color(UIColor.systemGray5))
            )
    }
}

struct AddIngredientView: View{
    @Binding var isPresented: Bool
    
    //data
    @Query var ingredients:[Ingredient]
    @Environment(\.modelContext) var context:ModelContext
    @State var isAlertPresented:Bool = false
    @State var ingredientName:String = ""
    var body: some View{
        VStack{
            Text("Add An Ingredients")
                .font(.title)
            
            ZStack{
                RoundedRectangle(
                    cornerRadius: 16)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                    .frame(width: 300, height: 300)
                    .foregroundColor(Color(UIColor.systemGray3)
                )
                Text("Choose An Image (Optional)")
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(UIColor.systemGray5))
                    )
            }
            HStack{
                Spacer()
                HStack{
                    Text("Name")
                    TextField("Name of ingredient", text: $ingredientName)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(UIColor.systemGray6))
                )
            }
            .padding(50)
            HStack{
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Cancle")
                        .font(.headline)
                        .foregroundColor(Color(UIColor.systemGray))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                }
                .frame(width: 150)
                .padding(.leading, 55)
            
                Spacer()
                Button {
                    if ingredientName.isEmpty{
                        isAlertPresented.toggle()
                    }else{
                        context.insert(Ingredient(name: ingredientName))
                        do{
                            try context.save()
                            isPresented.toggle()
                        }catch{
                            print("data not saved")
                        }
                    }
                } label: {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .frame(width: 150)
                .padding(.trailing,50)
                .alert(isPresented: $isAlertPresented) {
                    Alert(
                        title: Text("Hey!"),
                        message: Text("You forget to enter an ingredient name!"),
                        dismissButton: .default(Text("OK"))
                    )
                }

            }

        }
    }
}


#Preview {
    MyIngredientsView()
        .modelContainer(previewContainer)
}
