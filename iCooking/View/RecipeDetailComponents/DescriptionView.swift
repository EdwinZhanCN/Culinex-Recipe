//
//  DescriptionView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct DescriptionView: View {
    @Binding var discription: String
    @Binding var tools: [String]
    @State private var inputTool: String = ""
    @State private var isShowingSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                isShowingSheet.toggle()
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description & Tools")
                        .font(.headline)
                    
                    if !discription.isEmpty {
                        Text(discription)
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if !tools.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tools, id: \.self) { tool in
                                    Text(tool)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.secondary.opacity(0.2))
                                        )
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $isShowingSheet) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Description")
                            .font(.title2)
                        
                        TextField("Enter description", text: $discription, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(5...10)
                        
                        Text("Tools")
                            .font(.title2)
                            .padding(.top)
                        
                        HStack {
                            TextField("Add tool", text: $inputTool)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                if !inputTool.isEmpty && !tools.contains(inputTool) {
                                    tools.append(inputTool)
                                    inputTool = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .foregroundStyle(.blue)
                            }
                            .disabled(inputTool.isEmpty)
                        }
                        
                        // Tool Tags
                        FlowLayout(spacing: 8) {
                            ForEach(tools, id: \.self) { tool in
                                HStack(spacing: 4) {
                                    Text(tool)
                                    
                                    Button {
                                        tools.removeAll { $0 == tool }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .imageScale(.small)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .font(.subheadline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.secondary.opacity(0.2))
                                )
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Edit Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            isShowingSheet = false
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            isShowingSheet = false
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

// Helper view for flowing layout of tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var height: CGFloat = 0
        var width: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRow: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > (proposal.width ?? 0) {
                currentX = 0
                currentRow += size.height + spacing
            }
            
            currentX += size.width + spacing
            width = max(width, currentX)
            height = currentRow + size.height
        }
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += size.height + spacing
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
        }
    }
}
