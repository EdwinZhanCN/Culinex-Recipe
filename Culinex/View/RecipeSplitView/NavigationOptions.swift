//
//  NavigationOptions.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

/// An enumeration of navigation options in the app.
enum NavigationOptions: Equatable, Hashable, Identifiable {
    /// A case that represents viewing the app's home featuring with often accessed recipes and statistics.
    case home
    /// A case that represents viewing the app's recipe library, organized by card views.
    case recipes
    /// A case that represents viewing the app's ingredient library, organized by card views.
    case ingredients
    /// A case that represents viewing the app's collection of skills.
    case skills
    /// A case that represents viewing the favorite collection of recipes.
    case favorites
    
    
    
    static let mainPages: [NavigationOptions] = [.home, .recipes, .ingredients, .skills, .favorites]
    
    var id: String {
        switch self {
        case .home: return "Home"
        case .recipes: return "Recipes Library"
        case .ingredients: return "Ingredients Library"
        case .skills: return "Skills Library"
        case .favorites: return "Favorites Collection"
        }
    }
    
    var name: LocalizedStringResource {
        switch self {
        case .home: LocalizedStringResource("Home", comment: "Title for the Landmarks Home, shown in the sidebar.")
        case .recipes: LocalizedStringResource("Recipes Library", comment: "Title for the Recipes Library tab, shown in the sidebar.")
        case .ingredients: LocalizedStringResource(
            "Ingredients Library",
            comment: "Title for the Ingredients Library tab, shown in the sidebar."
        )
        case .skills: LocalizedStringResource(
            "Skills Library",
            comment: "Title for the Skills Library tab, shown in the sidebar."
        )
        case .favorites: LocalizedStringResource(
            "Favorites Collection",
            comment: "Title for the Favorites Collection tab, shown in the sidebar."
        )
        }
    }
    
    var symbolName: String {
        switch self {
        case .home: "house"
        case .recipes: "list.bullet.rectangle.portrait"
        case .ingredients: "carrot"
        case .skills: "graduationcap"
        case .favorites: "star"
        }
    }
    
    /// A view builder that the split view uses to show a view for the selected navigation option.
    @MainActor @ViewBuilder func viewForPage() -> some View {
        switch self {
        case .home:
            RecipesView()
        case .recipes:
            RecipesView()
        case .ingredients:
            IngredientsView()
        case .skills:
            SkillsGrid(forEditing: false)
        case .favorites:
            FavoritesGrid()
        }
    }
}
