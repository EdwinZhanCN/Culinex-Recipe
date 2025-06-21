//
//  StepEditorFormOptions.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import Foundation
import SwiftUI

enum StepEditorFormOptions: Equatable, Hashable, Identifiable, CaseIterable {
    case setIngredients
    case setTimer
    case setSkills
    case setTools
    case setDescription
    
    var id: String {
        switch self {
        case .setIngredients: return "Set Ingredients"
        case .setTimer: return "Set Timer"
        case .setSkills: return "Set Skills"
        case .setTools: return "Set Tools"
        case .setDescription: return "Set Description"
        }
    }
    
    var symbolName: String {
        switch self {
        case .setIngredients: "carrot"
        case .setTimer: "timer"
        case .setSkills: "graduationcap"
        case .setTools: "hammer"
        case .setDescription: "pencil"
        }
    }
    
    var symbolColor: Color {
        switch self {
        case .setIngredients: return .orange
        case .setTimer: return .blue
        case .setSkills: return .red
        case .setTools: return .indigo
        case .setDescription: return .gray
        }
    }
    
    var title: String {
        switch self {
        case .setIngredients: return "Ingredients"
        case .setTimer: return "Timer"
        case .setSkills: return "Skills"
        case .setTools: return "Tools"
        case .setDescription: return "Description"
        }
    }
}
