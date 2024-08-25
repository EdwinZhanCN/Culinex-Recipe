import SwiftUI

struct RecipeView: View{
    var body: some View{
        StepPanel()
    }
}

struct StepPanel:View{
    var body: some View{
        Text("Step")
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 800,height: 300)
    }
}

#Preview {
    RecipeView()
}
