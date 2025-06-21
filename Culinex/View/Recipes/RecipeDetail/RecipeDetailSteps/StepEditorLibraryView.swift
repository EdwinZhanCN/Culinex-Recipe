//
//  StepEditorLibraryView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/20/25.
//


import SwiftUI
import SwiftData
import Foundation

struct GenericLibraryListView<T: PersistentModel & LibraryItem>: View {
    @Environment(\.modelContext) private var modelContext
    
    // 查询的类型是泛型 T，可以是 Book，也可以是 Movie
    @Query private var items: [T]
    
    // 导航栏标题
    private var navigationTitle: String
    
    init(sort: SortDescriptor<T>, navigationTitle: String) {
        // 使用 _items 的初始化器来设置自定义的查询（例如排序）
        _items = Query(sort: [sort])
        self.navigationTitle = navigationTitle
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.displayName)
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(navigationTitle)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

protocol LibraryItem: Identifiable {
    var displayName: String { get }
}
