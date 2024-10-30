import SwiftUI
import SwiftData

struct ContentView: View {
    //Data
    @Environment(\.modelContext) private var context
    @Query(sort: \FavoriteItem.name) private var favoriteItems: [FavoriteItem]
    
    //SiderBar
    @State private var selectedItem:SideBarItem? = .overview
    
    //Favorite Recipes
    @State private var createFavoriteExpanded = false
    
    
    var body: some View {
        NavigationSplitView{
            //SiderBar
            List(selection:$selectedItem){
                //The SiderBaritems
                ForEach(SideBarItem.allCases, id: \.self){item in
                    NavigationLink(item.localizedName,value: item)    
                }
                
                //The heading of Favorite part
                HStack{
                    Text("Favorite Recipes")
                        .font(.headline)
                    Spacer()
                    if(!favoriteItems.isEmpty){
                        EditButton()
                    }
                }
                //The favorites
                ForEach(favoriteItems){ favorite in
                    DisclosureGroup(favorite.name) {
                        ForEach(favorite.recipes, id: \.id) { recipe in
                            Text(recipe.name)
                        }
                    }
                }
                .onDelete { indexSet in
                    deleteFavorite(at: indexSet)
                }
                
                //The bottom button that toggle a sheet to create favorite recipes
                Button(action: {
                    createFavoriteExpanded = true
                }, label: {
                    HStack{
                        Image(systemName: "plus.circle")
                        Text("Add your favorite recipes")
                    }
                })
                .foregroundStyle(Color.blue)
                .buttonStyle(.bordered)
            }
            .navigationTitle("Magic Recipe")
            .listStyle(SidebarListStyle())
        } detail:{
            //Show corresponding view of each sider bar item
            if let selectedItem = selectedItem {
                detailViewFactory(selectedItem)
            }
        }
        .sheet(isPresented: $createFavoriteExpanded, content: {
            AddFavoriteView(
                isPresented: $createFavoriteExpanded
            )
        })//the sheet that can pop out for creating favorite group
    }
    
    
    
    private func deleteFavorite(at indexSet: IndexSet) {
        for index in indexSet {
            let item = favoriteItems[index]
            context.delete(item)
        }
    }
}

//The enum of SiderBar items
enum SideBarItem:String, CaseIterable{
    case overview = "🏠Overview"
    case recipesLibrary = "🧾Recipes Library"
    case ingredients = "🥕My Ingredients"
    case timer = "⏱️Timer"
    
    var localizedName: String {
        self.rawValue
    }
}

//The function to show the corresponding view of each side bar item
func detailViewFactory(_ selectedItem: SideBarItem) -> some View{
    switch selectedItem{
    case .overview:
        return AnyView(OverviewView())
    case .recipesLibrary:
        return AnyView(RecipesLibraryView())
    case .ingredients:
        return AnyView(MyIngredientsView())
    case .timer:
        return AnyView(TimerView())
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}





