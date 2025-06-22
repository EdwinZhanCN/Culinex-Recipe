//
//  Tool.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import Foundation
import SwiftData


struct Tool: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var description: String?
    
    static func == (lhs: Tool, rhs: Tool) -> Bool {
        lhs.name == rhs.name && lhs.description == rhs.description
    }
    
    init(name: String, description: String? = nil) {
        self.name = name
        self.description = description
    }
}

