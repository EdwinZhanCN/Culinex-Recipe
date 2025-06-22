//
//  SetSkillView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//


import SwiftUI
import SwiftData

struct SetSkillView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]
    var body: some View {
        List(skills) { skill in
            Text(skill.name)
                .foregroundStyle(.primary)
        }
    }
}