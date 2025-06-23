//
//  作为静态工具方法的命名空间.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//


import Foundation
import SwiftData

// 使用没有 case 的 enum 作为静态工具方法的命名空间
enum FavoritesManager {
    
    /**
     一个全局可用的静态方法，用于将任意菜谱添加到“个人收藏”合集中。
     - Parameters:
        - recipe: 需要被添加的菜谱对象。
        - context: 当前的 SwiftData ModelContext。
     - Returns: 一个描述操作结果的字符串，例如“已添加”或“已存在”。
     */
    @MainActor // 标记此函数在主线程上执行，确保对 ModelContext 的操作是安全的
    static func add(recipe: Recipe, toFavoritesIn context: ModelContext) -> String {
        
        // 1. 定义获取 "Favorites" 合集的描述符
        let favoritesID = FavoriteCollection.favoritesID
        let predicate = #Predicate<FavoriteCollection> { $0.id == favoritesID }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            // 2. 尝试从数据库中获取 "Favorites" 合集对象
            guard let favoritesCollection = try context.fetch(descriptor).first else {
                // 这是一个重要的错误处理。如果因为某些原因没找到 "Favorites" 合集，
                // 我们应该返回一个清晰的错误信息。
                print("Error: The 'Favorites' collection could not be found.")
                return "操作失败：找不到个人收藏夹"
            }
            
            // 3. 调用 FavoriteCollection 实例上的 addRecipe 方法
            // 这个方法本身会处理菜谱是否已存在的逻辑
            let message = favoritesCollection.addRecipe(recipe)
            
            // 4. 返回实例方法提供的结果信息
            return message
            
        } catch {
            // 如果数据库 fetch 操作失败，捕获错误并返回
            print("Failed to fetch or add to Favorites collection: \(error)")
            return "数据库操作失败"
        }
    }
}