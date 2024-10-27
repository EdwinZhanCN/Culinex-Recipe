import SwiftUI


/// The IngredientsView takes the array of ingredients from viewmodel and pass it to the smaller components
struct MyIngredientsView: View{
    @StateObject var ingredientsViewModel: IngredientsViewModel = IngredientsViewModel()
    var body: some View{
        NavigationStack{
            ScrollView{
                ForEach(ingredientsViewModel.ingredients){ ingredient in
                    IngredientViewComponent(Ingredient: ingredient)
                        .padding()
                }
            }
            .navigationTitle("Ingredients Library")
            .listStyle(PlainListStyle())
        }
    }
}


struct IngredientViewComponent: View{
    var Ingredient: Ingredient
    var body: some View{
            VStack {
                HStack{
                    if let image = Ingredient.image {
                        Image(image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                    } else {
                        // Deal with no image
                        Image(systemName: "photo") // Using system image
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                    }
                    Text(Ingredient.name)
                        .font(.title)
                        .padding(.leading, 20)
                       
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 500)
            }
            .foregroundStyle(.primary)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .padding(-12)
                    .foregroundStyle(Color(UIColor.systemGray))
            )
    }
}


#Preview {
    MyIngredientsView()
}
