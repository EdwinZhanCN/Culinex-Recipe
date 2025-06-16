//
//  SkillSelectionView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct SkillSelectionView: View {
    @Query(sort: \Skill.name) var skills: [Skill]
    @Binding var selectedSkills: [Skill]
    @State private var searchText: String = ""
    
    // Computed property to filter ingredients based on searchText
    private var filteredSkills: [Skill] {
        if searchText.isEmpty {
            return skills
        } else {
            return skills.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                GeneralSearchBar(SeachText: $searchText, placeholder: "Search Skills")
                    .padding(.horizontal)
                ForEach(filteredSkills) { skill in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.title3)
                            Text(skill.category)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // Selection indicator
                        if selectedSkills.contains(where: { $0.id == skill.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedSkills.contains(where: { $0.id == skill.id })
                                ? Color.green
                                : Color(uiColor: .systemGray5),
                                lineWidth: 4
                            )
                            .background(
                                Color(UIColor.systemGray6).cornerRadius(8)
                            )
                    )
                    .onTapGesture {
                        if let index = selectedSkills.firstIndex(where: { $0.id == skill.id }) {
                            selectedSkills.remove(at: index)
                        } else {
                            selectedSkills.append(skill)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top,10)
                }
            }
            .padding(.horizontal)
        }
    }
}
