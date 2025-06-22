//
//  CalculatorNumberPickerView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//


import SwiftUI

struct CalculatorNumberPickerView: View {
    // 1. 绑定外部的 quantity，这样我们的修改可以直接生效
    @Binding var quantity: Double
    
    // 2. 内部状态，用于管理当前在“计算器屏幕”上的输入
    @State private var currentInput: String = ""
    
    // 3. 用于关闭 sheet
    @Environment(\.presentationMode) var presentationMode
    
    // 定义键盘布局
    private let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"] // ⌫ 是删除符号
    ]
    
    private let fractionKeys: [String: Double] = [
        "¼": 0.25, "½": 0.5, "¾": 0.75, "⅓": 0.333, "⅔": 0.666
    ]

    var body: some View {
        VStack(spacing: 12) {
            // MARK: - 显示屏
            Text(currentInput.isEmpty ? "0" : currentInput)
                .font(.system(size: 60, weight: .light))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 20)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            // MARK: - 分数快捷键
            HStack(spacing: 12) {
                ForEach(fractionKeys.keys.sorted(), id: \.self) { key in
                    Button(action: { handleFractionTap(key) }) {
                        Text(key)
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)

            // MARK: - 数字键盘
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        Button(action: { handleKeyTap(key) }) {
                            Text(key)
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: - 完成按钮
            Button(action: {
                // 将当前输入转换为 Double 并更新绑定的 quantity
                quantity = Double(currentInput) ?? 0
                // 关闭 sheet
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .onAppear {
            // 当视图出现时，用外部传入的 quantity 初始化输入框
            if quantity > 0 {
                // 同样使用格式化，但这里我们只需要小数形式
                self.currentInput = String(format: "%g", quantity)
            }
        }
        .preferredColorScheme(.dark) // 计算器通常在深色模式下更好看
    }
    
    // MARK: - 逻辑处理
    private func handleKeyTap(_ key: String) {
        switch key {
        case "⌫":
            if !currentInput.isEmpty {
                currentInput.removeLast()
            }
        case ".":
            // 确保只有一个小数点
            if !currentInput.contains(".") {
                currentInput += key
            }
        default: // 数字
            currentInput += key
        }
    }
    
    private func handleFractionTap(_ key: String) {
        guard let fractionValue = fractionKeys[key] else { return }
        
        // 获取当前输入的整数部分
        let currentDouble = Double(currentInput) ?? 0
        let wholePart = floor(currentDouble)
        
        // 新的值 = 整数部分 + 分数值
        let newValue = wholePart + fractionValue
        
        self.currentInput = String(format: "%g", newValue)
    }
}