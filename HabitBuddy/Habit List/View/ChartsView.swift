//
//  ChartsView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 12/12/24.
//

import SwiftUI
import Charts

struct HabitData: Identifiable {
    let id = UUID()
    let date: String
    let progress: Int // Percentage of habits completed
}

struct ChartsView: View {
    @State private var habitProgressData: [HabitData] = []
    @State private var bestDay: String = "N/A"
    @State private var worstDay: String = "N/A"
    @State private var completionBreakdown: (completed: Int, incomplete: Int) = (0, 0)
    @State private var individualHabitProgress: [String: Int] = [:]
    
    private let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    createHabitProgressSection()
                    createStreakProgressSection()
                    createCompletionBreakdownSection()
                    createBestWorstDaysSection()
                    createIndividualHabitProgressSection()
                }
                .padding()
            }
        }
        .onAppear {
            loadMetrics()
        }
    }
    
    // MARK: - Sections
    private func createHabitProgressSection() -> some View {
        VStack(spacing: 10) {
            Text("Habit Progress")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Chart(habitProgressData) { data in
                BarMark(
                    x: .value("Day", data.date),
                    y: .value("Progress", data.progress)
                )
                .foregroundStyle(Color.orange)
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
                                .foregroundColor(.white)
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
        }
    }
    
    private func createStreakProgressSection() -> some View {
        VStack(spacing: 10) {
            Text("Streak Progress")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Chart(habitProgressData) { data in
                LineMark(
                    x: .value("Day", data.date),
                    y: .value("Progress", data.progress)
                )
                .foregroundStyle(Color.blue)
                .symbol(Circle())
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .frame(height: 300)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
            )
        }
    }
    
    private func createCompletionBreakdownSection() -> some View {
        VStack(spacing: 10) {
            Text("Completion Breakdown")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            PieChartView(
                data: [
                    ("Completed", Double(completionBreakdown.completed), Color.green),
                    ("Incomplete", Double(completionBreakdown.incomplete), Color.red)
                ]
            )
            .frame(height: 300)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
            )
        }
    }
    
    private func createBestWorstDaysSection() -> some View {
        VStack(spacing: 10) {
            Text("Best & Worst Days")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack {
                VStack {
                    Text("Best Day")
                        .foregroundColor(.green)
                        .font(.headline)
                    Text(bestDay)
                        .foregroundColor(.white)
                        .font(.title2)
                }
                Spacer()
                VStack {
                    Text("Worst Day")
                        .foregroundColor(.red)
                        .font(.headline)
                    Text(worstDay)
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
            )
        }
    }
    
    private func createIndividualHabitProgressSection() -> some View {
        VStack(spacing: 10) {
            Text("Individual Habit Progress")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Chart {
                ForEach(Array(individualHabitProgress.keys), id: \.self) { habit in
                    BarMark(
                        x: .value("Progress", individualHabitProgress[habit]!),
                        y: .value("Habit", habit)
                    )
                    .foregroundStyle(Color.purple)
                }
            }
            .frame(height: 300)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
            )
        }
    }
    
    // MARK: - Metrics Loading
    private func loadMetrics() {
        loadHabitProgressData()
        let bestWorst = HabitService.shared.getBestAndWorstDays()
        bestDay = bestWorst.bestDay
        worstDay = bestWorst.worstDay
        completionBreakdown = HabitService.shared.getCompletionBreakdown()
        individualHabitProgress = HabitService.shared.getHabitProgressForWeek()
    }
    
    private func loadHabitProgressData() {
        let habitProgress = HabitService.shared.habitProgress
        let calendar = Calendar.current
        
        habitProgressData = daysOfWeek.compactMap { day in
            if let weekdayIndex = dayOfWeekIndex(day),
               let startOfWeek = calendar.date(from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())),
               let date = calendar.date(byAdding: .day, value: weekdayIndex - 1, to: startOfWeek),
               let progress = habitProgress.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                let percentage = (progress.totalHabits > 0)
                    ? (progress.completedHabits * 100) / progress.totalHabits
                    : 0
                return HabitData(date: day, progress: percentage)
            }
            return HabitData(date: day, progress: 0)
        }
    }
    
    private func dayOfWeekIndex(_ day: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.weekdaySymbols.firstIndex(where: { $0.hasPrefix(day) })?.advanced(by: 1)
    }
}

// MARK: - Pie Chart View
struct PieChartView: View {
    let data: [(String, Double, Color)] // Label, value, color

    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let total = data.reduce(0) { $0 + $1.1 }

            // Compute slices
            var startAngle: Angle = .zero
            let slices = data.map { element -> (startAngle: Angle, endAngle: Angle, data: (String, Double, Color)) in
                let endAngle = startAngle + .degrees((element.1 / total) * 360)
                defer { startAngle = endAngle }
                return (startAngle, endAngle, element)
            }

            ZStack {
                ForEach(Array(slices.enumerated()), id: \.offset) { index, slice in
                    PieSliceShape(startAngle: slice.startAngle, endAngle: slice.endAngle)
                        .fill(slice.data.2)
                }
                ForEach(Array(slices.enumerated()), id: \.offset) { index, slice in
                    let midAngle = slice.startAngle + (slice.endAngle - slice.startAngle) / 2
                    let xOffset = cos(midAngle.radians) * (radius * 0.7)
                    let yOffset = sin(midAngle.radians) * (radius * 0.7)

                    Text(slice.data.0)
                        .font(.caption)
                        .foregroundColor(.white)
                        .position(
                            x: geometry.size.width / 2 + xOffset,
                            y: geometry.size.height / 2 - yOffset
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle - .degrees(90),
            endAngle: endAngle - .degrees(90),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    ChartsView()
}
