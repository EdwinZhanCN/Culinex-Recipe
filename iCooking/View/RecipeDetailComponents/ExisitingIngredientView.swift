//
//  ExisitingIngredientView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct ExisitingIngredientView: View {
    @Query(sort: \Ingredient.name) var ingredients: [Ingredient]
    @Binding var selectedIngredients: [Ingredient]
    @State var searchText: String = ""

    // Computed property to filter ingredients based on searchText
    private var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                GeneralSearchBar(SeachText: $searchText, placeholder: "Search Ingredients")
                    .padding(.horizontal)
                ForEach(filteredIngredients) { ingredient in
                    HStack {
                        if let imageData = ingredient.image {
                            if let uiImage = UIImage(data: imageData){
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        } else {
                            // Deal with no image
                            Image(systemName: "photo") // Using system image
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text(ingredient.name)
                            .font(.title3)
                        
                        Spacer()
                        
                        // Selection indicator
                        if selectedIngredients.contains(where: { $0.id == ingredient.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedIngredients.contains(where: { $0.id == ingredient.id }) 
                                ? Color.green 
                                : Color(uiColor: .systemGray5),
                                lineWidth: 4
                            )
                            .background(
                                Color(UIColor.systemGray6).cornerRadius(8)
                            )
                    )
                    .onTapGesture {
                        if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                            selectedIngredients.remove(at: index)
                        } else {
                            selectedIngredients.append(ingredient)
                        }
                    }
                    .onDrag {
                        NSItemProvider(object: ingredient.id.uuidString as NSString)
                    }
                    .padding(.horizontal)
                    .padding(.top,10)
                }
            }
        }
    }
}

struct GeneralSearchBar: View{
    @Binding var SeachText: String
    var placeholder: String
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(.systemGray6))
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: $SeachText)
            }
            .padding(8)
            .padding()
        }
    }
}
