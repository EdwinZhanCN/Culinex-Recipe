//
//  StepFullScreenView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/6/24.
//

import SwiftUI
import SwiftData

struct StepFullScreenView: View {
    @State private var currentStep: Int? = 1
    private var totalSteps: Int = 4
    private var sampleTime: StepTime = StepTime(value: 5, unit: .sec)
    
    @State private var countdownTime: Double = 0
    @State private var timerActive = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Step \(currentStep ?? 1)/\(totalSteps)")
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 6))
                    .backgroundStyle(.blue.gradient)
                
                if showNotification {
                    HStack {
                        Text(notificationMessage)
                            .padding()
                        Spacer()
                        Button(action: {
                            closeNotification()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.9))
                    .cornerRadius(10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding()
                } else{
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    Button {
                        startTimer()
                    } label: {
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.green, .indigo)
                    }
                    
                    Text("\(String(format: "%.1f", countdownTime)) \(sampleTime.unit.toString(value: sampleTime.value))")
                        .padding()
                        .foregroundStyle(.orange)
                        .background(in: RoundedRectangle(cornerRadius: 6))
                        .backgroundStyle(.tertiary)
                }
            }
            
            RoundedRectangle(cornerRadius: 8)
            
            Spacer()
        }
        .padding(30)
    }
    
    func startTimer() {
        countdownTime = sampleTime.value
        timerActive = true
        showNotification = false // Hide any previous notification
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdownTime > 0 {
                countdownTime -= 1
            } else {
                timer.invalidate()
                timerActive = false
                showEndNotification()
            }
        }
    }
    
    func showEndNotification() {
        notificationMessage = "Timer has ended!"
        withAnimation(.easeOut(duration: 0.4)) { // Smooth entrance
            showNotification = true
        }
    }
    
    func closeNotification() {
        withAnimation(.easeInOut(duration: 0.3)) { // Smooth exit
            showNotification = false
        }
    }
}
    
    
