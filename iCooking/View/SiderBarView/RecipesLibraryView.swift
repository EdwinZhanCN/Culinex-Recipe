import SwiftUI

struct RecipesLibraryView: View{
    @StateObject private var recipesViewModel = RecipesViewModel()
    var body: some View{
        NavigationStack{
        }
    }
}

func RecipeCard(_ image:String, _ title:String) -> some View{
    ZStack{
        RoundedRectangle(cornerRadius: 25.0)
        HStack{
            Image(image)
            Text(title)
                .font(.title)
                .bold()
        }
    }
}

#Preview{
    RecipesLibraryView()
}

