//
//  SkillARQuickLook.swift
//  iCooking
//
//  Created by 詹子昊 on 11/4/24.
//
import SwiftUI
import QuickLook

struct ARQuickLookView: UIViewControllerRepresentable {
    let modelURL: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {
        // No update needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(modelURL: modelURL)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let modelURL: URL

        init(modelURL: URL) {
            self.modelURL = modelURL
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return modelURL as QLPreviewItem
        }
    }
}
