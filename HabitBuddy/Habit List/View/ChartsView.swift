import SwiftUI
import Charts

struct HabitData: Identifiable {
    let id = UUID()
    let date: String
    let progress: Int
}

struct ChartsView: View {
    @State private var habitProgressData: [HabitData] = []
    @State private var bestDay: String = "N/A"
    @State private var worstDay: String = "N/A"
    @State private var completionBreakdown: (completed: Int, incomplete: Int) = (0, 0)
    @State private var selectedChart: ChartType? = nil

    private let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.09, blue: 0.13).ignoresSafeArea()

            VStack(spacing: 20) {
                // Habit Progress Section
                createHabitProgressSection()
                    .frame(height: 250)
                    .onTapGesture { selectedChart = .habitProgress }

                // Pie Chart & Line Chart Side-by-Side
                HStack(spacing: 20) {
                    createCompletionBreakdownSection()
                        .frame(height: 250)
                        .onTapGesture { selectedChart = .completionBreakdown }
                    
                    createStreakProgressSection()
                        .frame(height: 250)
                        .onTapGesture { selectedChart = .streakProgress }
                }
                
                // Best & Worst Days
                createBestWorstDaysSection()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .onAppear { loadMetrics() }
        }
        .sheet(item: $selectedChart) { chartType in
            EnlargedChartView(chartType: chartType, habitProgressData: habitProgressData, completionBreakdown: completionBreakdown)
        }
    }

    // MARK: - Sections
    private func createHabitProgressSection() -> some View {
        ChartCard(title: "Habit Progress") {
            Chart(habitProgressData) { data in
                BarMark(x: .value("Day", data.date), y: .value("Progress", data.progress))
                    .foregroundStyle(Color.orange)
                    .annotation(position: .top) {
                        Text("\(data.progress)%")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) {
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private func createCompletionBreakdownSection() -> some View {
        ChartCard(title: "Completion Breakdown") {
            PieChartView(data: [
                ("Completed", Double(completionBreakdown.completed), Color.green),
                ("Incomplete", Double(completionBreakdown.incomplete), Color.red)
            ])
        }
    }

    private func createStreakProgressSection() -> some View {
        ChartCard(title: "Streak Progress") {
            Chart(habitProgressData) { data in
                LineMark(x: .value("Day", data.date), y: .value("Progress", data.progress))
                    .foregroundStyle(Color.blue)
                    .symbol(Circle())
            }
        }
    }

    private func createBestWorstDaysSection() -> some View {
        VStack(spacing: 10) {
            Text("Best & Worst Days")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            HStack(spacing: 20) {
                VStack {
                    Text("Best Day").foregroundColor(.green).font(.headline)
                    Text(bestDay).foregroundColor(.white).font(.title2)
                }
                Spacer()
                VStack {
                    Text("Worst Day").foregroundColor(.red).font(.headline)
                    Text(worstDay).foregroundColor(.white).font(.title2)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.6)))
        }
    }

    private func loadMetrics() {
        loadHabitProgressData()
        let bestWorst = HabitService.shared.getBestAndWorstDays()
        bestDay = bestWorst.bestDay
        worstDay = bestWorst.worstDay
        completionBreakdown = HabitService.shared.getCompletionBreakdown()
    }

    private func loadHabitProgressData() {
        let habitProgress = HabitService.shared.habitProgress
        let calendar = Calendar.current

        habitProgressData = daysOfWeek.compactMap { day in
            if let weekdayIndex = dayOfWeekIndex(day),
               let startOfWeek = calendar.date(from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())),
               let date = calendar.date(byAdding: .day, value: weekdayIndex - 1, to: startOfWeek),
               let progress = habitProgress.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                let percentage = (progress.totalHabits > 0) ? (progress.completedHabits * 100) / progress.totalHabits : 0
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

import SwiftUI

struct EnlargedChartView: View {
    let chartType: ChartType
    let habitProgressData: [HabitData]
    let completionBreakdown: (completed: Int, incomplete: Int)

    var body: some View {
        VStack(spacing: 20) {
            // Handle to allow drag and tap to close
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundColor(.gray)
                .onTapGesture { dismissView() }
                .padding(.top, 10)

            // Chart Title
            Text(chartType.title)
                .font(.title)
                .foregroundColor(.white)
                .padding()

            // Conditional View for Chart
            switch chartType {
            case .habitProgress:
                Chart(habitProgressData) {
                    BarMark(x: .value("Day", $0.date), y: .value("Progress", $0.progress))
                        .foregroundStyle(.orange)
                }
                .chartYScale(domain: 0...105)
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .foregroundStyle(.white)
                        AxisGridLine()
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .foregroundStyle(.white)
                        AxisGridLine()
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }
                .padding()

            case .completionBreakdown:
                VStack {
                    PieChartView(data: [
                        ("Completed", Double(completionBreakdown.completed), Color.green),
                        ("Incomplete", Double(completionBreakdown.incomplete), Color.red)
                    ])
                    .frame(height: 300)

                    // Display Completed and Incomplete Numbers
                    HStack(spacing: 30) {
                        VStack {
                            Text("Completed")
                                .foregroundColor(.green)
                                .font(.headline)
                            Text("\(completionBreakdown.completed)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        VStack {
                            Text("Not Completed")
                                .foregroundColor(.red)
                                .font(.headline)
                            Text("\(completionBreakdown.incomplete)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 20)
                }

            case .streakProgress:
                Chart(habitProgressData) {
                    LineMark(x: .value("Day", $0.date), y: .value("Progress", $0.progress))
                        .foregroundStyle(.blue)
                        .symbol(Circle())
                }
                .chartYScale(domain: 0...105)
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .foregroundStyle(.white)
                        AxisGridLine()
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .foregroundStyle(.white)
                        AxisGridLine()
                            .foregroundStyle(.white.opacity(0.3))
                    }
                }
                .padding()
            }
            Spacer()
        }
        .background(Color(red: 0.09, green: 0.09, blue: 0.13).ignoresSafeArea())
    }

    // Function to dismiss the view
    @Environment(\.dismiss) private var dismiss
    private func dismissView() {
        dismiss()
    }
}

enum ChartType: Identifiable {
    case habitProgress, completionBreakdown, streakProgress

    var id: Int { hashValue }
    var title: String {
        switch self {
        case .habitProgress: return "Habit Progress"
        case .completionBreakdown: return "Completion Breakdown"
        case .streakProgress: return "Streak Progress"
        }
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.6)))
    }
}

// MARK: - PieChartView
struct PieChartView: View {
    let data: [(String, Double, Color)] // Label, value, color

    var body: some View {
        GeometryReader { geometry in
            let total = data.reduce(0) { $0 + $1.1 }
            let slices = computeSlices(total: total)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.75

            ZStack {
                // Draw Pie Slices
                ForEach(slices.indices, id: \.self) { index in
                    let slice = slices[index]
                    PieSliceShape(startAngle: slice.start, endAngle: slice.end)
                        .fill(slice.color)
                }

                // Draw Labels Inside Each Slice
                ForEach(slices.indices, id: \.self) { index in
                    let slice = slices[index]
                    let midAngle = slice.start + (slice.end - slice.start) / 2
                    let adjustedMidAngle = midAngle - .degrees(90)
                    let labelRadius = radius * 0.6

                    let labelX = center.x + CGFloat(cos(adjustedMidAngle.radians)) * labelRadius
                    let labelY = center.y + CGFloat(sin(adjustedMidAngle.radians)) * labelRadius

                    if total > 0 {
                        let percentage = Int((slice.value / total) * 100)
                        if percentage > 0 {
                            Text("\(percentage)%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .position(x: labelX, y: labelY)
                        }
                    }
                }
            }
        }
    }

    // Precompute Pie Slices with Values
    private func computeSlices(total: Double) -> [(start: Angle, end: Angle, value: Double, color: Color)] {
        var startAngle: Angle = .zero
        return data.map { element in
            let endAngle = startAngle + .degrees((element.1 / total) * 360)
            let slice = (start: startAngle, end: endAngle, value: element.1, color: element.2)
            startAngle = endAngle
            return slice
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
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - .degrees(90),
                    endAngle: endAngle - .degrees(90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}

#Preview {
    ChartsView()
}
