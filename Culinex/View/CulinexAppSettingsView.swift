//
//  SettingsView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//


import SwiftUI

struct CulinexAppSettingsView: View {
    // --- 存储属性 (与上一步相同) ---
    @AppStorage("username") private var username: String = ""
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled: Bool = false
    @AppStorage("quantityDisplayStyle") private var displayStyle: QuantityDisplayStyle = .fraction
    @AppStorage("isCulinexIntelligenceEnabled") private var isCulinexIntelligenceEnabled: Bool = false
    
    // 从环境中获取关闭 sheet 的方法
    @Environment(\.dismiss) var dismiss

    var body: some View {
        // NavigationStack 让我们能拥有标题栏和工具栏按钮
        NavigationStack {
            // Form 会自动提供平台原生的设置样式
            Form {
                Section(header: Text("Username"), footer: Text("Your username will be your recipe author.")
                    .font(.footnote)) {
                    TextField("Your name here", text: $username)// A footnote
                        .textContentType(.username) // 提供系统键盘优化
                        .autocapitalization(.none) // 禁用自动大写
                        .disableAutocorrection(true) // 禁用自动更正
                        .textInputAutocapitalization(.never) // 禁用自动大写
                }
                
                Section(header: Text("Notifications")) {
                    // Toggle 直接绑定到我们的 @AppStorage 布尔值
                    Toggle("Get notified when new recipes are added", isOn: $isNotificationsEnabled)
                }
                
                Section(header: Text("Display Settings")) {
                    // Picker 也直接绑定到我们的 @AppStorage 枚举
                    Picker("Ingredients display", selection: $displayStyle) {
                        // 遍历我们之前创建的 QuantityDisplayStyle 的所有情况
                        ForEach(QuantityDisplayStyle.allCases, id: \.self) { style in
                            Text(style.label).tag(style)
                        }
                    }
                    // .segmented 样式在设置中很常用
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("About")) {
                    // Link 是一个方便跳转到网页的视图
                    Link("Privacy Policy", destination: URL(string: "https://www.apple.com")!)
                    
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary) // 设置主文本颜色
                        Spacer()
                        // 以编程方式获取应用版本号，非常专业
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Intelligence"), footer: Text("Use Apple native intelligence to enhance your experience.")) {
                    if #available(iOS 26.0, *) {
                        GenerativeSettingView()
                    } else {
                        Text("Intelligence is available on iOS/iPadOS/MacOS 26.0 and later.")
                    }
                }
            }
            .navigationTitle("Settings") // 设置导航栏标题
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 在工具栏添加一个 "完成" 按钮来关闭这个页面
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss() // 调用 dismiss 来关闭 sheet
                    }
                }
            }
        }
    }
}
