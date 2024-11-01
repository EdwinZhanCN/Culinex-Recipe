import SwiftUI

struct OverviewView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Divider()
            .background(Color(.systemGray6))
        GeometryReader { geometry in
            VStack {
                Image("Banner2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        VStack(alignment: .leading, content: {
                            Text("Magic Recipe")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .black : .black)
                        })
                    })
                    .frame(width: geometry.size.width*1, height: geometry.size.height*0.3)
                Spacer()
                ScrollView(.vertical, content: {
                    startPanel()
                })
                Spacer()
            }
            .background(Color("BannerColor1").ignoresSafeArea(.all))
        }
    }
}

struct startPanel: View {
    @State private var path: [Recipe] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Get Start")
                    .font(.title)
                    .bold()
                    .padding(.leading, 10)
                Spacer()
            }
            
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            Spacer()
                            startPanelCard(
                                image: "Seasoning",
                                title: "Learn to use seasonings",
                                description: "This guide is your key to mastering the art of seasoning, transforming your culinary skills."
                            )
                            
                            startPanelCard(
                                image: "Skill",
                                title: "Learn Kitchen skill",
                                description: "Your gateway to simple, delicious recipes."
                            )
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            startPanelCard(
                                image: "Recipe",
                                title: "Create your own recipes",
                                description: "Your gateway to simple, delicious recipes."
                            )
                            
                            startPanelCard(
                                image: "Cooking",
                                title: "Start cook your meal",
                                description: "your platform to explore, innovate, and share your cooking passion."
                            )
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(height: 500)
    }
}

struct startPanelCard: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemBackground))
            .shadow(color: Color(.systemGray4), radius: 2, y: 3)
            .overlay(content: {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title2)
                            .bold()
                        Text(description)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
            })
    }
}

#Preview {
    startPanel()
}

