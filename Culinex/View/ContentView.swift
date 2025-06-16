import SwiftUI
import SwiftData
import LucideIcons

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
                    NavigationLink(value: item) {
                        HStack {
                            #if canImport(UIKit)
                            if let uiImage = UIImage(lucideId: item.iconName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primary)
                            }
                            #elseif canImport(AppKit)
                            if let nsImage = NSImage.image(lucideId: item.iconName) {
                                Image(nsImage: nsImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primary)
                            }
                            #endif
                            Text(item.displayName)
                        }
                    }
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
                            NavigationLink{
                                RecipeDetailView(
                                    recipe: recipe,
                                    isNewRecipe: false
                                )
                            } label:{
                                Text(recipe.name)
                            }
                            
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
                        #if canImport(UIKit)
                        if let uiImage = UIImage(lucideId: "plus-circle") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "plus.circle")
                        }
                        #elseif canImport(AppKit)
                        if let nsImage = NSImage.image(lucideId: "plus-circle") {
                            Image(nsImage: nsImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "plus.circle")
                        }
                        #endif
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
enum SideBarItem: String, CaseIterable{
    case overview
    case recipesLibrary
    case ingredients
    case skills
    
    var displayName: String {
        switch self {
        case .overview:
            return "Overview"
        case .recipesLibrary:
            return "Recipes Library"
        case .ingredients:
            return "My Ingredients"
        case .skills:
            return "Skills"
        }
    }
    
    var iconName: String {
        switch self {
        case .overview:
            return "house"
        case .recipesLibrary:
            return "book"
        case .ingredients:
            return "banana"
        case .skills:
            return "graduation-cap"
        }
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
    case .skills:
        return AnyView(SkillsLibraryView())
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
