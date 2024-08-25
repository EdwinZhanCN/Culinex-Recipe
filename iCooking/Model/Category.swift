import Foundation

struct Category: Identifiable{
    var id:UUID
    var name:String
    var Recipes:[Recipe]
}

