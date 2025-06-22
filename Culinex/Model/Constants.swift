//
//  Constants.swift
//  Culinex
//
//  Created by 詹子昊 on 6/19/25.
//

import SwiftUI

struct Constants {
    // MARK: - IngredientGrid
        static let ingredientGridSpacing: CGFloat = 14.0
    @MainActor static var ingredientGridItemMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 240.0
        } else {
            return 160.0
        }
            
        #else
        return 240.0
        #endif
    }
    static let ingredientGridItemMaxSize: CGFloat = 320.0
    @MainActor static var ingredientGridItemEditingMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 180.0
        } else {
            return 140.0
        }
            
        #else
        return 180.0
        #endif
    }
    static let ingredientGridEditingMaxSize: CGFloat = 240.0
    
    // MARK: - RecipeGrid
    static let recipeGridSpacing: CGFloat = 14.0
    @MainActor static var recipeGridItemMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 240.0
        } else {
            return 160.0
        }
            
        #else
        return 240.0
        #endif
    }
    static let recipeGridItemMaxSize: CGFloat = 320.0
    @MainActor static var recipeGridItemEditingMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 180.0
        } else {
            return 140.0
        }
            
        #else
        return 180.0
        #endif
    }
    static let recipeGridItemEditingMaxSize: CGFloat = 240.0
    
    // MARK: - FavoriteCollectionGrid
    static let favoriteCollectionGridSpacing: CGFloat = 14.0
        @MainActor static var favoriteCollectionGridItemMinSize: CGFloat {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 240.0
            } else {
                return 160.0
            }
                
            #else
            return 240.0
            #endif
        }
        static let favoriteCollectionGridItemMaxSize: CGFloat = 320.0
    
    // MARK: - SkillsGrid
    static let skillsGridSpacing: CGFloat = 16.0
    @MainActor static var skillsGridItemMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 320.0
        } else {
            return 300.0
        }
        #else
        return 350.0
        #endif
    }
    static let skillsGridItemMaxSize: CGFloat = 450.0
    @MainActor static var skillsGridItemEditingMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 180.0
        } else {
            return 120.0
        }
        #else
        return 180.0
        #endif
    }
    static let skillsGridItemEditingMaxSize: CGFloat = 260.0
    
    // MARK: - RecipeInspector
    static let recipeInspectorMaxWidth: CGFloat = 600
    static let recipeInspectorMinWidth: CGFloat = 400
    static let recipeInspectorIdealWidth: CGFloat = 500
}
