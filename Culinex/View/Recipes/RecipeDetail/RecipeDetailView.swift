//
//  RecipeDetailView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI
import PhotosUI

enum InspectorState: Hashable {
    case idle
    case info(RecipeStep)
    case editing(RecipeStep)
}

struct RecipeDetailView: View {
    // passing the recipe model from parent to the view
    @Bindable var recipe: Recipe
    
    // 单一的状态源，管理所有检查器相关的状态
    @State private var inspectorState: InspectorState = .idle
    @State private var inspectorPresented: Bool = false
    @State private var isEditing: Bool = false

    var body: some View {
        RecipeDetailStepsView(
            recipe: recipe,
            state: $inspectorState, // 传递 state 的绑定
            inspectorPresented: $inspectorPresented // 传递 inspectorPresented 的绑定
        )
        .inspector(isPresented: $inspectorPresented) {
            RecipeDetailInspectorForm(
                recipe: recipe,
                state: $inspectorState // 同样传递 state 的绑定
            )
            .inspectorColumnWidth(225)
        }
        .sheet(isPresented: $isEditing) {
            RecipeInfoEditingSheet(recipe: recipe)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isEditing.toggle()
                } label: {
                    Label("Edit Recipe", systemImage: "square.and.pencil")
                }
            }
            ToolbarItem {
                Button {
                    print("Share tapped")
                } label: {
                    Label("Recipe Info", systemImage: "square.and.arrow.up")
                }
            }
            
            ToolbarSpacer(.fixed)
                        
            ToolbarItemGroup (placement: .automatic){
                RecipeDetailToolbar(
                    inspectorPresented: $inspectorPresented,
                    inspectorState: $inspectorState
                )
            }
        }
    }
}



struct RecipeDetailToolbar: View {
    @Binding var inspectorPresented: Bool
    @Binding var inspectorState: InspectorState

    var body: some View {
        Button {
            inspectorPresented = true
            inspectorState = .idle
        } label: {
            Label("Recipe Info", systemImage: "info")
        }
    
 
        Button {
            inspectorPresented.toggle()
        } label: {
            Label("Toggle Inspector", systemImage: "sidebar.trailing")
        }
    }
}

struct RecipeInfoEditingSheet: View {
    @Bindable var recipe: Recipe
    @State private var selectedPhoto: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form{
            Section(header: HStack{
                Text("Recipe Details")
                    .font(.title)
                Spacer()
                Button {
                    dismiss() // Dismiss the sheet
                }label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                }
            }) {
                TextField("Recipe Name", text: $recipe.name)
                TextField("Summary", text: $recipe.summary)
                HStack {
                    Text("Calories")
                    Spacer()
                    TextField("Value", value: $recipe.calories, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Servings")
                    Spacer()
                    TextField("Value", value: $recipe.servingSize, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section(header: Text("Recipe Image")) {
                if let imageData = recipe.Image, let uiImage = UIImage(
                    data: imageData
                ) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }

                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select a photo", systemImage: "photo")
                }
            }
        }
        .navigationTitle("Edit Recipe")
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    recipe.Image = data
                }
            }
        }
    }
}

