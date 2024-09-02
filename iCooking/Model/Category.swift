import Foundation

class Category: Identifiable{
    var id:UUID = UUID()
    var name:String = ""
    var Recipes:[Recipe] = []
}

