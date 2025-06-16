//
//  StepFullScreenView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/6/24.
//

import SwiftUI
import SwiftData

struct StepFullScreenView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Binding var steps: [RecipeStep]
    @State private var currentStepIndex: Int = 0
    @State private var showingNextStepPreview = false
    
    // MARK: - Dashboard Layout Properties
    private let dashboardSpacing: CGFloat = 20
    private var currentStep: RecipeStep {
        // 安全检查，防止 steps 为空或索引越界
        guard !steps.isEmpty, steps.indices.contains(currentStepIndex) else {
            // 返回一个默认的空步骤，避免崩溃
            return RecipeStep(
                ingredients: [],
                description: "No step data available.",
                skills: [],
                tools: [],
                duration: StepTime(value: 0, unit: .min)
            )
        }
        return steps[currentStepIndex]
    }
    private var isLastStep: Bool {
        currentStepIndex == steps.count - 1
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(uiColor: .systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: dashboardSpacing) {
                    // Top status bar
                    headerBar
                    
                    // Main content grid
                    dashboardGridLayout(size: geometry.size)
                    
                    // Navigation controls
                    StepNavigationControls(
                        currentStep: $currentStepIndex,
                        totalSteps: steps.count,
                        showingNextStepPreview: $showingNextStepPreview,
                        isLastStep: isLastStep,
                        dismiss: dismiss
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.top)
            }
        }
        .overlay(alignment: .top) {
            if showingNextStepPreview && !isLastStep {
                nextStepPreview
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: showingNextStepPreview)
        .animation(.easeInOut, value: currentStepIndex)
        .navigationBarHidden(true)
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var headerBar: some View {
        VStack(spacing: 8) {
            HStack {
                // Step indicator
                StepHeaderView(currentStep: currentStepIndex + 1, totalSteps: steps.count)
                
                Spacer()
                
                // Exit button
                Button {
                    dismiss()
                } label: {
                    Label("Exit", systemImage: "xmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly) // 只显示图标，更简洁
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            
            // Progress bar
            ProgressView(value: Double(currentStepIndex + 1), total: Double(steps.count))
                .tint(.blue)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func dashboardGridLayout(size: CGSize) -> some View {
        ScrollView {
            VStack(spacing: dashboardSpacing) {
                // Timer component - Always at the top for visibility
                DashboardCard {
                    TimerDashboardView(time: steps[currentStepIndex].duration)
                        .id(currentStepIndex) // ✅ 正确：使用 .id 来重置视图
                }
                .frame(height: 160)
                
                // Primary content grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: dashboardSpacing),
                    GridItem(.flexible(), spacing: dashboardSpacing)
                ], spacing: dashboardSpacing) {
                    
                    // Description card
                    DashboardCard {
                        DescriptionDashboardView(
                            description: steps[currentStepIndex].descrip
                        )
                    }
                    .gridCellColumns(steps[currentStepIndex].ingredients.isEmpty && steps[currentStepIndex].tools.isEmpty ? 2 : 1)
                    
                    // Ingredients card (if available)
                    if !steps[currentStepIndex].ingredients.isEmpty {
                        DashboardCard {
                            IngredientsDashboardView(
                                ingredients: steps[currentStepIndex].ingredients
                            )
                        }
                    }
                    
                    // Tools card (if available)
                    if !steps[currentStepIndex].tools.isEmpty {
                        DashboardCard {
                            ToolsDashboardView(tools: steps[currentStepIndex].tools)
                        }
                    }
                }
                
                // Skills card (if available)
                if !steps[currentStepIndex].skills.isEmpty {
                    DashboardCard {
                        SkillsDashboardView(skills: steps[currentStepIndex].skills)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var nextStepPreview: some View {
        VStack {
            HStack {
                Text("Next Step Preview")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    withAnimation {
                        showingNextStepPreview = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            if currentStepIndex + 1 < steps.count {
                Text(steps[currentStepIndex + 1].descrip)
                    .lineLimit(2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.9))
        )
        .padding()
    }
}

// MARK: - Dashboard Card Wrapper View

struct DashboardCard<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // 确保内容从左上角开始
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .black.opacity(0.05), radius: 2)
            )
    }
}

// MARK: - Dashboard Component Views

struct TimerDashboardView: View {
    let time: StepTime
    @State private var isTimerRunning = false
    @State private var remainingSeconds: Int
    @State private var timerCompleted = false
    
    // Initialization
    init(time: StepTime) {
        self.time = time
        _remainingSeconds = State(initialValue: time.computeTotalSeconds())
    }
    
    // Computed Properties
    private var formattedTime: String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private var timerProgress: Double {
        let total = Double(time.computeTotalSeconds())
        if total == 0 { return 0 } // 避免除以零
        let remaining = Double(remainingSeconds)
        return max(0, min(1, (total - remaining) / total))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Label("Timer", systemImage: "timer")
                    .font(.headline)
                    .foregroundStyle(timerCompleted ? .red : .blue)
                
                Spacer()
                
                // Status Text
                Text(timerCompleted ? "Completed!" : (isTimerRunning ? "Running" : "Ready"))
                    .foregroundStyle(timerCompleted ? .red : (isTimerRunning ? .blue : .secondary))
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(timerCompleted ? .systemRed : (isTimerRunning ? .systemBlue : .systemGray5)).opacity(0.2))
                    )
            }
            
            // Timer Display
            ZStack {
                // Progress Circle
                Circle()
                    .stroke(
                        Color(timerCompleted ? .systemRed : .systemBlue).opacity(0.3),
                        lineWidth: 6
                    )
                
                Circle()
                    .trim(from: 0, to: timerCompleted ? 1 : timerProgress)
                    .stroke(
                        timerCompleted ? Color.red : Color.blue,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: timerProgress)
                
                // Time Display
                VStack(spacing: 4) {
                    Text(formattedTime)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(timerCompleted ? .red : .primary)
                        .contentTransition(.numericText())
                }
            }
            
            // Timer Controls
            HStack(spacing: 20) {
                // Reset Button
                Button {
                    withAnimation {
                        isTimerRunning = false
                        timerCompleted = false
                        remainingSeconds = time.computeTotalSeconds()
                    }
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                
                // Play/Pause Button
                Button {
                    withAnimation {
                        if timerCompleted {
                            timerCompleted = false
                            remainingSeconds = time.computeTotalSeconds()
                            isTimerRunning = true // 如果完成了，点击播放直接开始
                        } else {
                            isTimerRunning.toggle()
                        }
                    }
                } label: {
                    Label(isTimerRunning ? "Pause" : "Play",
                          systemImage: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 40))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(isTimerRunning ? .red : .green, Color(.systemGray4).opacity(0.3)) // 调整颜色对比度
                }
                .buttonStyle(.plain)
            }
        }
        // ✅ 移除：此 onChange 不再需要，因为 .id() 会处理重置
        // .onChange(of: time) { ... }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            guard isTimerRunning, remainingSeconds > 0 else { return }
            
            remainingSeconds -= 1
            
            if remainingSeconds <= 0 {
                withAnimation {
                    timerCompleted = true
                    isTimerRunning = false
                }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        .onDisappear {
            isTimerRunning = false
        }
    }
}


// MARK: - DescriptionView
struct DescriptionDashboardView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Label("Instructions", systemImage: "text.book.closed")
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            // Content
            ScrollView {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    // 移除 fixedSize, 让它在 ScrollView 中自由伸缩
            }
        }
    }
}

struct IngredientsDashboardView: View {
    let ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Ingredients (\(ingredients.count))", systemImage: "carrot")
                .font(.headline)
            
            Divider()
        
            ForEach(ingredients) { ingredient in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    Text(ingredient.name)
                        .font(.subheadline)
                    
                }
            }
        }
    }
}

struct ToolsDashboardView: View {
    let tools: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title with count
            Label("Tools (\(tools.count))", systemImage: "hammer")
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(tools, id: \.self) { tool in
                        HStack(spacing: 12) {
                            Image(systemName: "wrench.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue.opacity(0.7))
                            
                            Text(tool)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

struct SkillsDashboardView: View {
    let skills: [Skill]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title with count
            Label("Skills", systemImage: "star")
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            // Content
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(skills) { skill in
                        VStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            Text(skill.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 80)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.yellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Header & Navigation Components

struct StepHeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack {
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.blue.gradient)
                        .shadow(radius: 1)
                )
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct StepNavigationControls: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    @Binding var showingNextStepPreview: Bool
    let isLastStep: Bool
    let dismiss: DismissAction
    
    var body: some View {
        HStack(spacing: 20) {
            // Previous step button
            Button {
                withAnimation {
                    showingNextStepPreview = false
                    currentStep = max(0, currentStep - 1)
                }
            } label: {
                Label("Previous", systemImage: "chevron.backward")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.7))
                    )
            }
            .disabled(currentStep == 0)
            .opacity(currentStep == 0 ? 0.5 : 1)
            
            // Preview next step button
            if !isLastStep {
                Button {
                    withAnimation {
                        showingNextStepPreview.toggle()
                    }
                } label: {
                    Label("Preview Next", systemImage: "eye")
                        .symbolVariant(showingNextStepPreview ? .fill : .none)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple.opacity(0.7))
                        )
                }
            }
            
            // Next step or finish button
            Button {
                withAnimation {
                    if isLastStep {
                        dismiss()
                    } else {
                        showingNextStepPreview = false
                        currentStep = min(totalSteps - 1, currentStep + 1)
                    }
                }
            } label: {
                Label(isLastStep ? "Finish" : "Next",
                      systemImage: isLastStep ? "checkmark" : "chevron.forward")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isLastStep ? Color.green : Color.blue)
                    )
            }
        }
    }
}

// Helper extension for StepTime
extension StepTime {
    func computeTotalSeconds() -> Int {
        switch unit {
        case .hr: Int(value * 3600)
        case .min: Int(value * 60)
        case .sec: Int(value)
        }
    }
}
