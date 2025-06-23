//
//  RecipeGridItemView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//
import SwiftUI
// ===============================================================
// 视图定义
// ===============================================================

/// A card view for displaying a recipe in a grid layout.
struct RecipeGridItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var recipe: Recipe
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack (alignment: .top){
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.dynamicColor(for: recipe.name))
                // 2. 修复图标变形问题，并让它作为柔和的背景
                Image(systemName: "carrot.fill") // 使用 .fill 版本可能更好看
                    .resizable()
                    .scaledToFit() // <-- 关键：保持图标的宽高比
                    .foregroundColor(.white.opacity(0.3)) // 降低不透明度
                    .padding(25) // 给图标一些呼吸空间

                // 3. 内容层
                VStack {
                    Header(recipe: recipe)
                        .padding(.top) // 将 Header 向下推一点
                    Spacer()
                    RecipeInfo(recipe: recipe)
                        .padding(.horizontal) // 给左右一些边距
                        .padding(.bottom, 10) // 给底部一些边距
                }
            }
            .containerShape(.rect(cornerRadius: 20))

            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .padding(.top, 5)
                    .onAppear(perform: dismissToastAfterDelay)
            }
        }
        // 4. 使用单一的 containerShape 来定义卡片的最终形状和点击区域
        .contextMenu{
            Button{
                addCurrentRecipeToFavorites()
            }label: {
                Label("Add to Favorites", systemImage: "heart.fill")
                    .foregroundColor(.primary)
                    .font(.title2)
            }
        }
    }
    
    private func addCurrentRecipeToFavorites() {
        // 视图的职责被大大简化了。
        // 它只需要调用全局的管理器，而不需要知道任何关于如何获取收藏夹的内部逻辑。
        let message = FavoritesManager.add(recipe: recipe, toFavoritesIn: modelContext)
        
        // 使用返回的消息来显示 Toast
        toastMessage = message
        withAnimation { showToast = true }
    }
    
    private func dismissToastAfterDelay() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                showToast = false
            }
        }
    }
}

/// 顶部标题视图
struct Header: View {
    var recipe: Recipe
    
    var body: some View {
        HStack{
            Text(recipe.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.black.opacity(0.6), in: Capsule()) // 使用胶囊形状可能更美观
        }
        .padding(.horizontal, 12)
    }
}

/// 底部包含两个圆形信息单元的视图
struct RecipeInfo: View {
    var recipe: Recipe

    // (这里的格式化代码和你提供的一样，非常棒，无需修改)
    private var caloriesInfo: String {
        guard let calories = recipe.calories, calories > 0 else { return "N/A" }
        return "\(calories) kcal"
    }
    private var durationInfo: String {
        guard recipe.duration > 0 else { return "0 min" }
        return RecipeInfo.durationFormatter.string(from: recipe.duration) ?? "0 min"
    }
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    var body: some View {
        // 简化：HStack 只负责布局，具体的圆形样式交给 CircleInfoView
        HStack {
            CircleInfoView(info: caloriesInfo, icon: "flame.fill")
            Spacer()
            CircleInfoView(info: durationInfo, icon: "clock.fill")
        }
        // 将背景材质应用在 HStack 上，形成一个整体的底部信息栏
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}

/// 单个的、自包含的圆形信息单元
struct CircleInfoView: View {
    var info: String
    var icon: String // 新增：可以传入一个图标名

    var body: some View {
        // 在垂直方向上堆叠图标和文字
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.callout) // 合适的图标大小
            
            Text(info)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.primary) // 使用主色，能更好地适应亮色/暗色模式
        .frame(width: 70, height: 55) // 给一个合适的固定大小
    }
}


// MARK: - 颜色扩展 (无需修改)
extension Color {
    static func dynamicColor(for name: String) -> Color {
        let hash = name.hashValue
        let hue = Double(abs(hash % 360)) / 360.0
        let saturation = 0.4 + Double(abs(hash % 40)) / 100.0
        let brightness = 0.7 + Double(abs(hash % 30)) / 100.0 // 调亮一些，避免颜色过暗
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}
