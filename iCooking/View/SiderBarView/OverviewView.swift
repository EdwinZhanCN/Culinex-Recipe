import SwiftUI

struct OverviewView: View{
    var body: some View{
        Divider()
            .background(Color(.systemGray6))
        GeometryReader { geometry in
            VStack{
                Image("Banner2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        VStack(alignment:.leading, content: {
                            Text("Magic Recipe")
                                .font(.system(size: 50))
                                .bold()
                        })
                        
                    })
                    .frame(width: geometry.size.width*1, height: geometry.size.height*0.3)
                Spacer()
                ScrollView(.vertical, content: {
                    startPanel()
                })
                Spacer()
            }
            .background(Color("BannerColor1")
                .ignoresSafeArea(.all))
        }
    }
}


struct startPanel: View{
    @State private var path:[Recipe] = []
    var body: some View{
        VStack{
            HStack{
                Text("Get Start")
                    .font(.title)
                    .bold()
                    .padding(.leading,10)
                Spacer()
            }
            NavigationStack{
                GeometryReader{geometry in
                    VStack{
                        HStack{
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .shadow(color: .gray, radius: 2,y: 3)
                                .foregroundStyle(Color.white)
                                .overlay(content: {
                                    HStack{
                                        Image("Seasoning")
                                            .resizable()
                                            .scaledToFit()
                                        Spacer()
                                        VStack(alignment:.leading){
                                            Text("Learn to use seasonings")
                                                .font(.title2)
                                                .bold()
                                            Text("This guide is your key to mastering the art of seasoning, transforming your culinary skills.")
                                        }
                                        Spacer()
                                    }
                                })
                            RoundedRectangle(cornerRadius: 10)
                                .shadow(color: .gray, radius: 2,y: 3)
                                .foregroundStyle(Color.white)
                                .overlay(content: {
                                    HStack{
                                        Image("Skill")
                                            .resizable()
                                            .scaledToFit()
                                        Spacer()
                                        VStack(alignment:.leading){
                                            Text("Learn Kitchen skill")
                                                .font(.title2)
                                                .bold()
                                            Text("Your gateway to simple, delicious recipes.")
                                        }
                                        Spacer()
                                    }
                                })
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .shadow(color: .gray, radius: 2,y: 3)
                                .foregroundStyle(Color.white)
                                .overlay(content: {
                                    HStack{
                                        Image("Recipe")
                                            .resizable()
                                            .scaledToFit()
                                        Spacer()
                                        VStack(alignment:.leading){
                                            Text("Create your own recipes")
                                                .font(.title2)
                                                .bold()
                                            Text("Your gateway to simple, delicious recipes.")
                                        }
                                        Spacer()
                                    }
                                })
                            RoundedRectangle(cornerRadius: 10)
                                .shadow(color: .gray, radius: 2,y: 3)
                                .foregroundStyle(Color.white)
                                .overlay(content: {
                                    HStack{
                                        Image("Cooking")
                                            .resizable()
                                            .scaledToFit()
                                        Spacer()
                                        VStack(alignment:.leading){
                                            Text("Start cook your meal")
                                                .font(.title2)
                                                .bold()
                                            Text("your platform to explore, innovate, and share your cooking passion.")
                                        }
                                        Spacer()
                                    }
                                })
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(height: 500)
    }
}

#Preview(body: {
    startPanel()
})

