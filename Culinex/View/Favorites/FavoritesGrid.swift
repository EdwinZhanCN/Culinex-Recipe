//
//  FavoritesGrid.swift
//  Culinex
//
//  Created by 詹子昊 on 6/21/25.
//

import SwiftUI
import SwiftData

struct FavoritesGrid: View {
    @Query(sort: \FavoriteCollection.name) var favoriteCollections: [FavoriteCollection]
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var isShowingDeleteAlert = false
    @State private var collectionToDelete: FavoriteCollection?
    
    @State private var isShowingToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    ForEach(favoriteCollections) { collection in
                        NavigationLink(destination: FavoritesDetailView(favoriteCollection: collection)) {
                            FavoritesGridItemView(favoriteCollection: collection)
                                .contextMenu {
                                    // 只有当合集可删除时，才显示删除按钮
                                    if collection.isDeletable {
                                        Button(role: .destructive) {

                                            self.collectionToDelete = collection
                                            self.isShowingDeleteAlert = true
                                        } label: {
                                            Label("Delete Collection", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Collections")
            
            // Toast 视图 (你已有的，位置移到 ZStack 内)
            if isShowingToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 10)
                    .onAppear(perform: dismissToastAfterDelay)
            }
        }
        .alert(
            "Confirm Deletion",
            isPresented: $isShowingDeleteAlert,
            presenting: collectionToDelete // 将要删除的合集对象传递给 Alert
        ) { collection in
            // Alert 的按钮
            Button("delete", role: .destructive) {
                // --- 4. 在这里执行真正的删除和触发 Toast ---
                deleteAndShowToast(for: collection)
            }
            Button("Cancel", role: .cancel) {
                // 取消时，将 collectionToDelete 重置为 nil
                collectionToDelete = nil
            }
        } message: { collection in
            // Alert 的描述信息
            Text("Are you sure you want to delete \"\(collection.name)\"")
        }
    }
    
    // --- 辅助函数 ---
    
    private func deleteAndShowToast(for collection: FavoriteCollection) {
        let collectionName = collection.name // 先保存名字，因为删除后就访问不到了
        modelContext.delete(collection)
        showToast(message: "\"\(collectionName)\" deleted.")
    }
    
    private func showToast(message: String) {
        self.toastMessage = message
        withAnimation {
            self.isShowingToast = true
        }
    }
    
    private func dismissToastAfterDelay() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation {
                isShowingToast = false
            }
        }
    }
    
    private var columns: [GridItem] {
        [ GridItem(.adaptive(minimum: Constants.favoriteCollectionGridItemMinSize,
                             maximum: Constants.favoriteCollectionGridItemMaxSize),
                   spacing: Constants.favoriteCollectionGridSpacing) ]
    }
}
