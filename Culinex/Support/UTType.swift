//
//  UTType.swift
//  Culinex
//
//  Created by 詹子昊 on 6/20/25.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

// 1. 定义一个通用的 UTType，用于表示任何库项目
extension UTType {
    static let libraryItemIdentifier = UTType("com.culinex.libraryitem.identifier")!
}

// 2. 让 PersistentIdentifier 遵守 Transferable 协议
//    这个扩展一旦添加，整个 App 内都有效！
extension PersistentIdentifier: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        // 使用 CodableRepresentation 来进行数据转换，并用我们通用的 UTType 来标识
        CodableRepresentation(contentType: .libraryItemIdentifier)
    }
}
