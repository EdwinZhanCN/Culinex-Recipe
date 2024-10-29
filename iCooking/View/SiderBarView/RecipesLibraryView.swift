import SwiftUI

struct RecipesLibraryView: View{
    @StateObject private var recipesViewModel = RecipesViewModel()
    
    let columns = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
    ]
    
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(recipesViewModel.recipesLibrary) { item in
                    let color = Color.dynamicColor(for: item.name)
                    VStack{
                        ZStack {
                            color
                                .frame(width: 150, height: 200)
                                .cornerRadius(8)
                            
                            Image(systemName: "carrot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Text(item.name)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: 170)
                        
                }
            }
            .padding()
        }
    }
}

extension Color {
    static func dynamicColor(for name: String) -> Color {
        let hash = name.hashValue // 使用 name 的哈希值
        let hue = Double(abs(hash % 360)) / 360.0
        let saturation = 0.4 + Double(abs(hash % 40)) / 100.0
        let brightness = 0.5 + Double(abs(hash % 50)) / 100.0
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}

#Preview{
    RecipesLibraryView()
}

