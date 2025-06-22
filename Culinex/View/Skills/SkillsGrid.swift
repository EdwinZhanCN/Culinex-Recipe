//
//  SkillsGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//
import SwiftUI
import SwiftData
struct SkillsGrid: View {
    @Query(sort: \Skill.name, order: .forward) var skills: [Skill]
    
    @State var searchText: String = ""
    let forEditing: Bool
    
    var filteredskills: [Skill] {
        if searchText.isEmpty {
            return skills
        } else {
            return skills.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredskills) { skill in
                    // Link to the detail view
                    SkillCardView(skill: skill)
                }
                
            }
            .navigationTitle("Skills Library (\(skills.count) total)")
            .searchable(text: $searchText)
            .padding(20)
        }
    }
    
    private var columns: [GridItem] {
        if forEditing {
            return [ GridItem(.adaptive(minimum: Constants.skillsGridItemEditingMinSize,
                                        maximum: Constants.skillsGridItemEditingMaxSize),
                              spacing: Constants.skillsGridSpacing) ]
        }
        return [ GridItem(.adaptive(minimum: Constants.skillsGridItemMinSize,
                                    maximum: Constants.skillsGridItemMaxSize),
                          spacing: Constants.skillsGridSpacing) ]
    }
    
}
