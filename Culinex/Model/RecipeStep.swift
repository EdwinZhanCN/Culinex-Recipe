//
//  RecipeStep.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import Foundation
import SwiftData

@Model
class RecipeStep: Identifiable {
    var order: Int
    
    var descrip: String
    
    var tools: [Tool]?
    var duration: StepTime
    
    @Relationship(inverse: \Skill.recipeSteps) var skills = [Skill]()
    
    @Relationship(deleteRule: .cascade)
    var stepIngredients = [RecipeIngredient]()
    
    @Relationship(inverse: \Recipe.steps) var recipe: Recipe?

    init(
        description: String,
        duration: StepTime,
        order: Int
    ) {
        self.descrip = description
        self.duration = duration
        self.order = order
    }
    
    
    func getTimeInterval() -> TimeInterval {
        return duration.durationInSeconds
    }
}

extension Recipe {
    
    /// 计算属性：返回一个包含所有步骤中不重复技能的数组
    @Transient
    var allSkills: [Skill] {
        // 1. 拍平所有步骤中的技能数组
        let allSkillsInSteps = self.steps.flatMap { $0.skills }
        
        // 2. 使用 Set 来去除重复的技能
        // 注意：这要求 Skill 类型是 Hashable 的，\@Model 默认符合
        let uniqueSkills = Set(allSkillsInSteps)
        
        // 3. 转换回数组并排序，以确保显示顺序稳定
        return Array(uniqueSkills).sorted { $0.name < $1.name } // 假设 Skill 有一个 name 属性
    }
}
