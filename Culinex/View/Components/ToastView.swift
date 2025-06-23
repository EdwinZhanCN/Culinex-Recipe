//
//  ToastView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.thinMaterial, in: Capsule()) // 使用背景材质，有模糊效果
            .shadow(radius: 5)
    }
}
