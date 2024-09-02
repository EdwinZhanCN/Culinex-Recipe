import Foundation

class FavoriteItem: Identifiable{
    var id:UUID = UUID()
    var name:String = ""
    var recipes:[Recipe] = []
}
