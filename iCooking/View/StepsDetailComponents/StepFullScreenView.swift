//
//  StepFullScreenView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/6/24.
//

// File: StepFullScreenView.swift
import SwiftUI
import SwiftData

struct StepFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var steps: [RecipeStep]  // Passed from RecipeDetailView
    @State private var currentStepIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Progress indicator
                ProgressView(value: Double(currentStepIndex + 1), total: Double(steps.count))
                    .tint(.blue)
                    .padding(.horizontal)
                
                // Step content
                VStack(alignment: .leading, spacing: 16) {
                    StepHeaderView(currentStep: currentStepIndex + 1, totalSteps: steps.count)
                    
                    TimerView(time: steps[currentStepIndex].duration)
                        .id(currentStepIndex)
                    
                    // Step details
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(steps[currentStepIndex].descrip)
                                .font(.body)
                            
                            if !steps[currentStepIndex].ingredients.isEmpty {
                                IngredientsListView(ingredients: steps[currentStepIndex].ingredients)
                            }
                            
                            if !steps[currentStepIndex].tools.isEmpty {
                                ToolsListView(tools: steps[currentStepIndex].tools)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                
                // Navigation buttons
                StepNavigationButtons(
                    currentStep: $currentStepIndex,
                    totalSteps: steps.count,
                    dismiss: dismiss
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Exit") { dismiss() }
                }
            }
        }
    }
}

struct StepHeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack {
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.blue.gradient)
                .foregroundColor(.white)
                .clipShape(Capsule())
            Spacer()
        }
    }
}

struct TimerView: View {
    let time: StepTime
    @State private var isTimerRunning = false
    @State private var remainingSeconds: Int
    @State private var timerCompleted = false
    
    // 计算总秒数的独立方法
    private func computeTotalSeconds() -> Int {
        switch time.unit {
        case .hr: Int(time.value * 3600)
        case .min: Int(time.value * 60)
        case .sec: Int(time.value)
        }
    }
    
    // 格式化显示时间（00:00:00）
    private var formattedTime: String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    init(time: StepTime) {
        self.time = time
        _remainingSeconds = State(initialValue: time.computeTotalSeconds())
    }
    
    var body: some View {
        VStack {
            HStack {
                // 重置按钮
                Button {
                    isTimerRunning = false
                    timerCompleted = false
                    remainingSeconds = computeTotalSeconds()  // 修复1：使用正确计算方法
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blue, .gray)
                }
                
                // 播放/暂停按钮
                Button {
                    isTimerRunning.toggle()
                } label: {
                    Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(isTimerRunning ? .red : .green, .gray)
                }
                
                // 时间显示
                Text(formattedTime)
                    .font(.title2.monospacedDigit())
                    .padding(.horizontal)
                    .frame(minWidth: 100)
                    .foregroundStyle(timerCompleted ? .red : .primary)
                    .contentTransition(.numericText())
            }
            
            // 状态提示
            if isTimerRunning || timerCompleted {
                Text(timerCompleted ? "Time's up!" : "Timer running...")
                    .font(.caption)
                    .foregroundStyle(timerCompleted ? .red : .secondary)
            }
        }
        .onChange(of: time) { oldTime, newTime in
            isTimerRunning = false
            timerCompleted = false
            remainingSeconds = newTime.computeTotalSeconds()
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            guard isTimerRunning, remainingSeconds > 0 else { return }
            
            remainingSeconds -= 1
            
            if remainingSeconds <= 0 {
                timerCompleted = true
                isTimerRunning = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
        .onDisappear {
            isTimerRunning = false
        }
    }
}

// 扩展 StepTime 添加计算方法
extension StepTime {
    func computeTotalSeconds() -> Int {
        switch unit {
        case .hr: Int(value * 3600)
        case .min: Int(value * 60)
        case .sec: Int(value)
        }
    }
}

struct StepNavigationButtons: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let dismiss: DismissAction
    
    var body: some View {
        HStack {
            Button {
                withAnimation { currentStep -= 1 }
            } label: {
                Label("Previous", systemImage: "chevron.left")
                    .labelStyle(.titleAndIcon)
            }
            .disabled(currentStep == 0)
            
            Spacer()
            
            Button {
                if currentStep == totalSteps - 1 {
                    dismiss()
                } else {
                    withAnimation { currentStep += 1 }
                }
            } label: {
                Label(currentStep == totalSteps - 1 ? "Finish" : "Next",
                      systemImage: currentStep == totalSteps - 1 ? "checkmark" : "chevron.right")
                    .labelStyle(.titleAndIcon)
            }
        }
        .padding()
        .buttonStyle(.bordered)
    }
}

struct IngredientsListView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ForEach(ingredients) { ingredient in
                HStack(spacing: 12) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(.secondary)
                    
                    Text(ingredient.name)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct ToolsListView: View {
    let tools: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tools")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ForEach(tools, id: \.self) { tool in
                HStack(spacing: 12) {
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    Text(tool)
                        .font(.subheadline)
                }
            }
        }
    }
}
