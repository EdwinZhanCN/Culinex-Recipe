//
//  DataSetup.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//

import SwiftData
import Foundation

enum DataSetup {
    @MainActor
    static func createInitialCollections(context: ModelContext) {
        
        // --- 解决方案：将静态属性的值存入一个局部常量 ---
        let favoritesID = FavoriteCollection.favoritesID
        
        // 1. 定义一个 FetchDescriptor，并在 Predicate 中使用这个局部常量
        let descriptor = FetchDescriptor<FavoriteCollection>(
            predicate: #Predicate { $0.id == favoritesID } // ✅ 使用局部常量 favoritesID
        )
        
        do {
            // 2. 执行查询
            let existingFavorites = try context.fetch(descriptor)
            
            // 3. 如果查询结果为空 (count == 0)，则创建它
            if existingFavorites.isEmpty {
                let favoritesCollection = FavoriteCollection(
                    id: FavoriteCollection.favoritesID, // 这里使用静态属性没问题
                    name: "Favorites",
                    isDeletable: false
                )
                context.insert(favoritesCollection)
                print("Favorites collection created for the first time.")
            } else {
                print("Favorites collection already exists.")
            }
        } catch {
            fatalError("Failed to fetch or create initial data: \(error.localizedDescription)")
        }
    }
}
