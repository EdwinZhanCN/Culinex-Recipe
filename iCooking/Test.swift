//
//  Test.swift
//  iCooking
//
//  Created by 詹子昊 on 10/30/24.
//


import SwiftUI

struct DraggableTagView: View {
    // 标签库的标签数组
    let allTags = ["Swift", "UI Design", "AI", "Machine Learning", "Databases"]
    // 已选标签数组
    @State private var selectedTags: [String] = []
    
    var body: some View {
        VStack {
            Text("已选标签")
                .font(.headline)
                .padding()
            
            // 已选标签展示区域
            HStack {
                ForEach(selectedTags, id: \.self) { tag in
                    Text(tag)
                        .padding(8)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .frame(height: 50)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onDrop(of: [.text], isTargeted: nil) { providers in
                providers.first?.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                    if let data = data as? Data, let tag = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            // 避免重复添加标签
                            if !selectedTags.contains(tag) {
                                selectedTags.append(tag)
                            }
                        }
                    }
                }
                return true
            }
            
            Text("标签库")
                .font(.headline)
                .padding()
            
            // 标签库中的标签
            HStack {
                ForEach(allTags, id: \.self) { tag in
                    Text(tag)
                        .padding(8)
                        .background(Color.orange.opacity(0.3))
                        .cornerRadius(8)
                        .onDrag {
                            return NSItemProvider(object: tag as NSString)
                        }
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    DraggableTagView()
}

