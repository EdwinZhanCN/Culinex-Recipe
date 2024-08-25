import Foundation

struct FavoriteItem: Identifiable{
    var id:UUID = UUID()
    var name:String
    var recipes:[Recipe]
}
