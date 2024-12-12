//
//  ChartsView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 12/12/24.
//

import Foundation
import SwiftUI
import Charts

struct HabitData: Identifiable {
    let id = UUID()
    let date: String
    let progress: Int // Percentage of habits completed
}

struct ChartsView: View {
    @State private var habitProgressData: [HabitData] = []
    private let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Habit Progress")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Chart
                Chart(habitProgressData) { data in
                    BarMark(
                        x: .value("Day", data.date),
                        y: .value("Progress", data.progress)
                    )
                    .foregroundStyle(Color.orange)
                    
                    // Annotation for value on top of each bar
                    .annotation(position: .top) {
                        Text("\(data.progress)%")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel {
                            if let day = value.as(String.self) {
                                Text(day)
                                    .foregroundColor(.white) // Set day label color to white
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                )
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print("Debug - Chart Data: \(HabitService.shared.habitProgress)")
            loadHabitProgressData()
        }
    }
    
    // Load habit progress data from HabitService
    private func loadHabitProgressData() {
        let habitProgress = HabitService.shared.habitProgress
        let calendar = Calendar.current

        print("Debug - Habit Progress Data from Service: \(habitProgress)")

        habitProgressData = daysOfWeek.compactMap { day in
            // Map the day to a specific date
            if let weekdayIndex = dayOfWeekIndex(day),
               let startOfWeek = calendar.date(from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())),
               let date = calendar.date(byAdding: .day, value: weekdayIndex - 1, to: startOfWeek) {

                // Find progress data for the specific day
                if let progress = habitProgress.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                    let percentage = (progress.totalHabits > 0)
                        ? (progress.completedHabits * 100) / progress.totalHabits
                        : 0
                    print("Debug - HabitData for \(day): \(percentage)%")
                    return HabitData(date: day, progress: percentage)
                }
            }

            print("Debug - No data for \(day)")
            return HabitData(date: day, progress: 0)
        }
    }
    
    // Map day name to weekday index (1 = Sunday, 7 = Saturday)
    private func dayOfWeekIndex(_ day: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.weekdaySymbols.firstIndex(where: { $0.hasPrefix(day) })?.advanced(by: 1)
    }
}

#Preview {
    ChartsView()
}
