import Foundation

class Ingredient: Identifiable{
    var id:UUID = UUID()
    var name:String
    var image:String?
    
    
    init(name: String, image: String?) {
        self.name = name
        self.image = image
    }
}

