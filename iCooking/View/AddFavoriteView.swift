import SwiftUI
import SwiftData



struct AddFavoriteView: View{
    @Query var favorites:[FavoriteItem]
    @Environment(\.modelContext) var context
        
    //Initialized
    @State var addedRecipes:[Recipe] = []
    
    @State var favoriteName:String = ""
    
    //The variable used to quit the sheet
    @State private var isPresentSheet:Bool = false
    
    //The variable that used to determine which recipes should be added into array
    @State private var multiSelection = Set<UUID>()
    
    //The alter toggle
    @State private var showAlert = false
    
    //Uninitialized
    //The variable used to quit
    @Binding var isPresented:Bool
    
    
    var body: some View{
        VStack{
            HStack(alignment:.firstTextBaseline){
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(.leading,10)
                
                Spacer()
                
                HStack{
                    Image(systemName: "heart")
                        .foregroundStyle(Color.red)
                        .padding(.leading, 8)
                    TextField("New favorite",text: $favoriteName)
                        .font(.title)
                        .frame(width:200,alignment: .center)
                        .padding(5)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    if !addedRecipes.isEmpty {
                        if favoriteName.isEmpty {
                            favoriteName = "New Favorite \(favorites.count + 1)"
                        }
                        // 引用现有的 Recipe 而不是重复插入
                        let newFavorite = FavoriteItem(name: favoriteName, recipes: addedRecipes)
                        context.insert(newFavorite)
                        do {
                            try context.save()
                        } catch {
                            print("Data not saved")
                        }
                        isPresented = false
                    } else {
                        showAlert.toggle()
                    }
                }, label: {
                    Text("Save")
                })
                .padding(.trailing, 10)
                .buttonStyle(.bordered)
                .foregroundStyle(Color.blue)
                
            }
            .padding(.top, 10)
            .padding(.bottom,10)
            
            Divider()
            ZStack{
                if(addedRecipes.isEmpty){
                    VStack{
                        Section(content: {
                            Button(action: {
                                isPresentSheet = true
                            }, label: {
                                HStack{
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add recipe")
                                        .font(.title3)
                                }
                                
                            })
                            .foregroundStyle(Color.blue)
                            .buttonStyle(.bordered)
                            
                        }, header: { 
                            Text("Create a collection of your favorite recipes!")
                                .foregroundStyle(Color(.gray))
                                .bold()
                        })
                        .transition(AnyTransition.opacity.animation(.easeIn))
                    }
                }else{
                    VStack{
                        HStack{
                            Spacer()
                            EditButton()
                                .padding(.trailing, 8)
                        }
                        List{
                            ForEach(addedRecipes){recipe in
                                Text(recipe.name)
                            }
                            .onDelete { offsets in
                                addedRecipes.remove(atOffsets: offsets)
                            }
                            .onMove { source, destination in
                                addedRecipes.move(fromOffsets: source, toOffset: destination)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            Spacer()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("You haven't add your recipes!"))
        })
        .sheet(isPresented: $isPresentSheet) {
            BottomSheetView(isPresented: $isPresentSheet,addedRecipes: $addedRecipes)
                .presentationDetents([.medium,.large])
                .presentationDragIndicator(.visible)
        }

    }
}


struct BottomSheetView:View{
    @Query var recipesLibrary:[Recipe]
    @State private var searchQuery = ""
    @State private var selectedRecipes = Set<UUID>()
    @Binding var isPresented: Bool
    @Binding var addedRecipes: [Recipe]
    
    
    var body: some View {
        Spacer()
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
                    
            TextField("Search you recipe in library", text: $searchQuery)
                .padding(8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
        NavigationView {
            VStack {
                List(filteredRecipes, id: \.id, selection: $selectedRecipes) { recipe in
                    Text(recipe.name)
                }
                .listStyle(.plain)
                Text("\(selectedRecipes.count) selections")                
            }
            .navigationTitle("Library")
            .toolbar {
                Button("Add Selected Recipes") {
                    for recipe in filteredRecipes where selectedRecipes.contains(recipe.id) {
                        if !addedRecipes.contains(where: { $0.id == recipe.id }) {
                            addedRecipes.append(recipe)
                        }
                    }
                     isPresented = false
                }
            }
        }
        
    }
    
    
    var filteredRecipes:[Recipe]{
        if searchQuery.isEmpty{
            return recipesLibrary
        }else{
            return recipesLibrary.filter{ recipe in
                recipe.name.localizedStandardContains(searchQuery)
            }
        }
    }
}

