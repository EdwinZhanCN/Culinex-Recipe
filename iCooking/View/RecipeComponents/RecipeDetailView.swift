import SwiftUI

struct RecipeDetailView: View {
    let steps = ["步骤 1", "步骤 2", "步骤 3"]
    let tools = ["控制", "App", "显示结果", "显示警报"]
    
    var body: some View {
        HStack(spacing:0){
            // 左侧步骤区域 (4/5 宽度)
            VStack (spacing:0){
                HStack{
                    HStack{
                        Image(systemName: "list.clipboard")
                            .font(.headline)
                        Text("步骤")
                            .font(.headline)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    HStack{
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.headline)
                        Text("工具")
                            .font(.headline)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                }
                .padding(.bottom,15)
                .background(Color(UIColor.systemGray6))
                HStack(spacing:0){
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(steps, id: \.self) { step in
                                Text(step)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal,80)
                    }
                    .padding(.top,20)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    VStack{
                        Text("New Step")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.4))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.vertical)
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Array(tools.enumerated()), id: \.1) { index,tool in
                                    HStack {
                                        Text(tool)
                                            .padding(10)
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                            .background(
                                                index % 2 == 0 ?
                                                Color(UIColor.systemGray6) :Color(UIColor.systemGray5)
                                            ) // 灰白交替
                                            .cornerRadius(8)
                                            .font(.footnote)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 20)
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



#Preview {
    RecipeDetailView()
}
