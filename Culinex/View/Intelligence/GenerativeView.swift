//
//  GenerativeView.swift
//  Culinex
//
//  Created by 詹子昊 on 6/22/25.
//
import SwiftUI
import FoundationModels

@available(iOS 26.0, *)
struct GenerativeSettingView: View {
    // Create a reference to the system language model.
    private var model = SystemLanguageModel.default
    @AppStorage("isCulinexIntelligenceEnabled") private var isCulinexIntelligenceEnabled: Bool = false


    var body: some View {
        switch model.availability {
        case .available:
            // Show your intelligence UI.
            Toggle("Culinex Intelligence", isOn: $isCulinexIntelligenceEnabled)
        case .unavailable(.deviceNotEligible):
            Text("This device is not eligible for Apple Intelligence.")
                .foregroundColor(.red)
        case .unavailable(.appleIntelligenceNotEnabled):
            HStack {
                Text("Apple Intelligence is not enabled on this device.")
                    .foregroundColor(.red)
                Button("Open System Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        case .unavailable(.modelNotReady):
            // The model isn't ready because it's downloading or because of other system reasons.
            HStack{
                Text("The intelligence model is not ready. Please wait until it downloads.")
                    .foregroundColor(.orange)
                Button("Open System Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        case .unavailable(let other):
            Text("Intelligence Unavailable")
        }
    }
}
    
