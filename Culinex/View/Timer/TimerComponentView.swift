//
//  TimerComponentView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//

import SwiftUI
import Combine

struct TimerComponentView: View {
    // 1. 使用 @Binding 替代 @State
    // 现在，剩余时间由父视图完全控制
    @Binding var remainingTime: TimeInterval
    
    // 这两个值在每次父视图刷新时都会被重新传入
    let totalTime: TimeInterval
    let isTimerActive: Bool
    
    // 定时器保持不变
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // 2. 简化 init
    // 不再需要 _remainingTime 的复杂初始化
    init(remainingTime: Binding<TimeInterval>, totalTime: TimeInterval, isTimerActive: Bool) {
        self._remainingTime = remainingTime
        self.totalTime = totalTime
        self.isTimerActive = isTimerActive
    }

    var body: some View {
        ZStack {
            CircularProgressView(progress: progress)

            Text(timeString(from: remainingTime))
                .font(.system(size: 30, weight: .thin, design: .monospaced))
                .padding(.horizontal, 10)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .onReceive(timer) { _ in
            guard isTimerActive else { return }
            if remainingTime > 0 {
                // 修改绑定值，从而直接修改父视图的状态
                remainingTime -= 1
            }
        }
    }
    
    private var progress: Double {
        guard totalTime > 0 else { return 0 }
        // remainingTime 现在是绑定值，所以进度计算总是最新的
        return max(0, remainingTime / totalTime)
    }

    // 3. 修改 timeString 函数，始终显示 HH:MM:SS
    private func timeString(from timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(max(0, timeInterval))
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        // 无论小时是否为0，都返回这个格式
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - 独立的圆环视图
struct CircularProgressView: View {
    let progress: Double // 进度值，从 0.0 到 1.0

    var body: some View {
        ZStack {
            // 背景圆环 (浅灰色)
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: 12
                )

            // 前景进度环 (绿色)
            Circle()
                // .trim() 是实现进度效果的关键
                // 从 0 开始，修剪到 progress 的位置
                .trim(from: 0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: 18, // 线条宽度
                        lineCap: .round // 圆角端点
                    )
                )
                // 将圆环旋转 -90 度，使起点在顶部
                .rotationEffect(.degrees(-90))
                // 添加动画，使进度变化更平滑
                .animation(.linear, value: progress)
        }
    }
}

