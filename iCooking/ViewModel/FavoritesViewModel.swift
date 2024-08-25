import SwiftUI
import Foundation

class FavoriteViewModel: ObservableObject{
    @Published var favorites:[FavoriteItem] = []
    
    func addFavorite(name:String, recipes:[Recipe]){
        let newFavorite = FavoriteItem(name: name, recipes: recipes)
        favorites.append(newFavorite)
    }
    
    func deleteFavorite(at offsets: IndexSet){
        favorites.remove(atOffsets: offsets)
    }
    
    func moveFavorite(from: IndexSet, to: Int){
        favorites.move(fromOffsets: from, toOffset: to)
    }
}
