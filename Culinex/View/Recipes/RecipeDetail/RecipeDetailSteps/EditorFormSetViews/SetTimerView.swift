//
//  SetTimerView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI
import SwiftData

struct SetTimerView: View {
    @Bindable var recipeStep: RecipeStep
    
    // 用于控制 popover 的显示状态
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            Text("Set Timer")
                .font(.title)
                .bold()
                .padding(.leading, 10)
            Form {
                Section {
                    TimerComponentView(
                        remainingTime: .constant(recipeStep.getTimeInterval()),
                        totalTime: recipeStep.getTimeInterval(),
                        isTimerActive: false
                    )
                    .frame(height: 250)
                } header: {
                    Text("Preview")
                }
                
                // ✅ Section 2: 新的编辑时长方式
                Section {
                    // 使用 LabeledContent 提供一个清晰的标签和内容布局
                    LabeledContent {
                        // 显示格式化后的当前时长
                        Text(recipeStep.duration.formattedString)
                            .foregroundStyle(.link)
                    } label: {
                        Text("Duration")
                            .font(.headline)
                    }
                    .contentShape(Rectangle()) // 让整个区域都可点击
                    .onTapGesture {
                        isShowingPicker = true // 点击时显示 popover
                    }
                    
                } header: {
                    Text("Edit Duration")
                }
            }
        }
        .popover(isPresented: $isShowingPicker, attachmentAnchor: .point(.center)) {
            // 在 popover 中展示我们的拨轮选择器视图
            DurationPickerView(duration: $recipeStep.duration)
                .frame(idealWidth: 380, idealHeight: 400)
                .presentationCompactAdaptation(.popover)
        }
    }
}

struct DurationPickerView: View {
    // 接收来自父视图的绑定
    @Binding var duration: StepTime
    
    // 用于关闭 popover
    @Environment(\.dismiss) private var dismiss
    
    // 内部状态，用于控制三个滚轮的当前值
    @State private var selectedHours: Int
    @State private var selectedMinutes: Int
    @State private var selectedSeconds: Int
    
    // 初始化时，将传入的 duration 分解为时、分、秒，为滚轮设置初始值
    init(duration: Binding<StepTime>) {
        self._duration = duration
        let totalSeconds = Int(duration.wrappedValue.durationInSeconds)
        
        self._selectedHours = State(initialValue: totalSeconds / 3600)
        self._selectedMinutes = State(initialValue: (totalSeconds % 3600) / 60)
        self._selectedSeconds = State(initialValue: totalSeconds % 60)
    }
    
    var body: some View {
        VStack {
            // 顶部工具栏，包含标题和完成按钮
            HStack {
                Spacer()
                Text("Set Timer").font(.headline)
                Spacer()
                Button("Done") {
                    saveAndDismiss()
                }
            }
            .padding()

            // 三个滚轮选择器
            HStack(spacing: 0) {
                // 小时滚轮
                Picker("hr", selection: $selectedHours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) hr").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 120)
                .clipped()
                
                // 分钟滚轮
                Picker("min", selection: $selectedMinutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
                
                // 秒滚轮
                Picker("sec", selection: $selectedSeconds) {
                    ForEach(0..<60) { second in
                        Text("\(second) sec").tag(second)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
            }
            Spacer()
        }
    }
    
    // 当点击"完成"时调用此函数
    private func saveAndDismiss() {
        // 1. 将选择的时、分、秒重组为总秒数
        let totalSeconds = TimeInterval((selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds)
        
        // 2. 创建一个新的 StepTime，并统一用秒作为单位存储
        // 这种标准化的存储方式更健壮
        duration = StepTime(value: totalSeconds, unit: .sec)
        
        // 3. 关闭 popover
        dismiss()
    }
}
