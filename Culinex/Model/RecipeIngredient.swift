//  RecipeIngredient.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import Foundation
import SwiftData


// 1. 定义一个可编码的、可迭代的枚举，用于用户设置
// Codable -> 让它可以被 AppStorage 存储
// CaseIterable -> 让我们可以在 Picker 中轻松遍历所有选项
enum QuantityDisplayStyle: String, Codable, CaseIterable {
    case fraction = "Fractions" // 分数
    case decimal = "Decimals"   // 小数
    
    // 用于 Picker 中显示的标签
    var label: String { self.rawValue }
}

@Model
final class RecipeIngredient: Identifiable {
    @Attribute(.unique) var id = UUID()
    var quantity: Double
    var unit: String
    
    // ... 您的关系属性保持不变 ...
    @Relationship(inverse: \RecipeStep.stepIngredients)
    var step: RecipeStep?
    var ingredient: Ingredient?
    
    init(quantity: Double, unit: String, ingredient: Ingredient, step: RecipeStep) {
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
        self.step = step
    }
    
    // MARK: - 新增的计算属性
    
    /// 根据用户选择的样式，返回格式化后的数量字符串
    /// - Parameter style: 用户期望的显示样式（分数或小数）
    /// - Returns: 格式化后的字符串
    @Transient // 使用 @Transient 确保 SwiftData 不会尝试存储这个计算属性
    var formattedQuantity: String {
        // 在这里，您可以决定一个默认的显示样式，或者要求调用者必须提供
        // 为了简单起见，我们暂时硬编码一个默认值，但更好的方式是让视图决定
        return format(using: .fraction) // 默认使用分数，下面会展示如何让视图控制
    }
    
    func format(using style: QuantityDisplayStyle) -> String {
        switch style {
        case .decimal:
            // 小数样式：最多保留两位小数
            return String(format: "%.2f", self.quantity)
        case .fraction:
            // 分数样式：使用我们之前创建的逻辑
            let fractions: [Double: String] = [
                0.25: "¼", 0.5: "½", 0.75: "¾",
                0.333: "⅓", 0.666: "⅔",
                0.125: "⅛", 0.375: "⅜", 0.625: "⅝", 0.875: "⅞"
            ]

            if quantity == floor(quantity) {
                return "\(Int(quantity))"
            }

            let wholePart = Int(floor(quantity))
            let decimalPart = quantity - Double(wholePart)

            for (decimal, fractionChar) in fractions {
                if abs(decimalPart - decimal) < 0.01 {
                    return wholePart == 0 ? fractionChar : "\(wholePart) \(fractionChar)"
                }
            }
            // 如果不是常见分数，则回退到小数显示
            return String(format: "%.2f", self.quantity)
        }
    }
}

/// Usage example:
//let step1 = RecipeStep(...)
//let flour = Ingredient(...)
//let flourUsage = RecipeIngredient(...)
//
//context.insert(step1)
