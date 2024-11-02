//
//  TimerSettingView.swift
//  iCooking
//
//  Created by 詹子昊 on 11/1/24.
//


import SwiftUI
import SwiftData

struct TimerSettingView: View {
    @Binding var durationValue: Double
    @Binding var durationUnit: UnitOfTime
    
    let timeUnits: [UnitOfTime] = [.sec, .min, .hr]
    let commonDurations = [5.0, 15.0, 30.0, 60.0]
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Set Duration")
                .font(.title2)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                // Common durations
                VStack(alignment: .leading) {
                    Text("Quick Select")
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 10) {
                        ForEach(commonDurations, id: \.self) { value in
                            Button {
                                durationValue = value
                            } label: {
                                Text("\(Int(value))")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(durationValue == value ? Color.accentColor : Color(UIColor.systemGray5))
                                    )
                                    .foregroundStyle(durationValue == value ? .white : .primary)
                            }
                        }
                    }
                }
                
                // Custom duration input
                VStack(alignment: .leading) {
                    Text("Custom Duration")
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        TextField("Value", value: $durationValue, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                        
                        Button {
                            isShowingPicker.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .imageScale(.large)
                        }
                    }
                    
                    if isShowingPicker {
                        Slider(
                            value: $durationValue,
                            in: 0...60,
                            step: durationUnit == .sec || durationUnit == .min ? 1.0 : 0.5
                        ) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("60")
                        }
                        .padding(.vertical)
                    }
                }
                
                // Time unit selection
                VStack(alignment: .leading) {
                    Text("Unit")
                        .foregroundStyle(.secondary)
                    
                    Picker("Time Unit", selection: $durationUnit) {
                        ForEach(timeUnits, id: \.self) { unit in
                            Text(unit.toString(value: durationValue))
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            // Preview of the set time
            if durationValue > 0 {
                Label(
                    "\(String(format: "%.1f", durationValue)) \(durationUnit.toString(value: durationValue))",
                    systemImage: "timer"
                )
                .font(.title3)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.tertiary)
                )
            }
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: isShowingPicker)
    }
}