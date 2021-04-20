//
//  ContentView.swift
//  BetterRest
//
//  Created by Terry Thrasher on 2021-04-19.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var wakeUp = defaultWakeTime
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // Challenge 3 asks me to always show the recommended bedtime, and remove the Calculate button.
    var calculatedWakeTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "There was a problem determining your bedtime!"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Challenge 1 asks me to replace all VStacks with Sections.
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                // Challenge 2 asks me to replace the stepper for a picker showing the same range of values
                Section(header: Text("Daily coffee intake")) {
                    Picker("Cups: ", selection: $coffeeAmount) {
                        ForEach((1...20), id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(header: Text("Your bedtime")) {
                    Text("\(calculatedWakeTime)")
                        .frame(width: 324, alignment: .center)
                        .font(.largeTitle)
                }
                .multilineTextAlignment(.center)
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
