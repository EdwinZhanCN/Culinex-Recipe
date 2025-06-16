//
//  DescriptionView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//

import SwiftUI
import SwiftData

struct DescriptionView: View {
    // MARK: - Properties
    @Binding var discription: String
    @Binding var tools: [String]
    @State private var inputTool: String = ""
    @State private var isShowingSheet = false
    @State private var isAnimating = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isShowingSheet.toggle()
                }
            } label: {
                summaryView
            }
            .buttonStyle(.plain)
        }
        .padding()
        .sheet(isPresented: $isShowingSheet, onDismiss: {
            withAnimation {
                isAnimating = false
            }
        }) {
            detailSheetView
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        isAnimating = true
                    }
                }
        }
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var summaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Label("Description & Tools", systemImage: "doc.text.fill")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(.accentColor)
                    .imageScale(.large)
                    .symbolEffect(.pulse, options: .repeating, value: isAnimating)
            }
            
            // Description Preview
            if !discription.isEmpty {
                Text(discription)
                    .lineLimit(3)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                    .padding(.trailing, 8)
            } else {
                Text("Add a description of this step...")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .italic()
            }
            
            // Tools Preview
            if !tools.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tools")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(tools, id: \.self) { tool in
                                ToolTag(name: tool)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.05), radius: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var detailSheetView: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Description Section
                    descriptionSection
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Tools Section
                    toolsSection
                }
                .padding()
                .opacity(isAnimating ? 1 : 0.7)
                .animation(.easeIn, value: isAnimating)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Edit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isShowingSheet = false
                    }
                    .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isShowingSheet = false
                        }
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(discription.isEmpty && tools.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(.thinMaterial)
        .scrollDismissesKeyboard(.interactively)
    }
    
    @ViewBuilder
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Description", systemImage: "text.alignleft")
                .font(.headline)
            
            TextField("Describe the step in detail...", text: $discription, axis: .vertical)
                .font(.body)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .lineLimit(5...10)
        }
    }
    
    @ViewBuilder
    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Tools", systemImage: "hammer.fill")
                .font(.headline)
            
            toolInputField
            
            if !tools.isEmpty {
                Text("Added tools:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                
                toolTagsGrid
            }
        }
    }
    
    @ViewBuilder
    private var toolInputField: some View {
        HStack {
            TextField("Add kitchen tool", text: $inputTool)
                .font(.body)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .submitLabel(.done)
                .onSubmit {
                    addToolIfValid()
                }
            
            Button {
                addToolIfValid()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
                    .font(.system(size: 30))
                    .contentShape(Circle())
            }
            .disabled(inputTool.isEmpty)
            .buttonStyle(.plain)
            .keyboardShortcut(.defaultAction)
        }
    }
    
    @ViewBuilder
    private var toolTagsGrid: some View {
        FlowLayout(spacing: 10) {
            ForEach(tools, id: \.self) { tool in
                HStack(spacing: 6) {
                    Text(tool)
                        .lineLimit(1)
                    
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            tools.removeAll { $0 == tool }
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.accentColor.opacity(0.15))
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: tools)
    }
    
    // MARK: - Helper Methods
    
    private func addToolIfValid() {
        let trimmedTool = inputTool.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTool.isEmpty && !tools.contains(trimmedTool) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                tools.append(trimmedTool)
                inputTool = ""
            }
        }
    }
}

// MARK: - Supporting Views

/// A visual tag for displaying a kitchen tool
struct ToolTag: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "utensils")
                .font(.system(size: 10))
            
            Text(name)
                .lineLimit(1)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.accentColor.opacity(0.15))
        )
        .overlay(
            Capsule()
                .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 0.5)
        )
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
