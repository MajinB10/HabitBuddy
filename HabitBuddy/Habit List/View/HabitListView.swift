//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 3/12/24.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var viewmodel = HabitListViewModel()
    @State var showHabitForm: Bool = false
    @State var isEditMode: Bool = false
    @State private var currentMotivationalQuote: String = ""
    @State private var animateHeader: Bool = false

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Array of motivational headers
    private let motivationalQuotes = [
        "Small Habits, Big Changes ✨",
        "Consistency is Key 🔑",
        "One Step at a Time 🪜",
        "You’ve Got This 💪",
        "Progress, Not Perfection 🚀",
        "Build Today, Thrive Tomorrow 🌱",
        "Great Things Start Small 🌟",
        "Keep the Streak Alive 🔥"
    ]
    
    // Helper function to generate dates for the current week (Mon to Sun)
    func generateWeekDates() -> [String] {
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d\nEEE"
        
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: weekStart) {
                return formatter.string(from: date)
            }
            return nil
        }
    }
    
    private func randomizeMotivationalQuote() {
        if let randomQuote = motivationalQuotes.randomElement() {
            currentMotivationalQuote = randomQuote
            animateHeader = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateHeader = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    // TOP SECTION
                    VStack(spacing: 20) {
                        // Motivational Header
                        Text(currentMotivationalQuote)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .opacity(animateHeader ? 1.0 : 0.0)
                            .scaleEffect(animateHeader ? 1.0 : 0.8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5), value: animateHeader)
                        
                        // Date & Streak
                        VStack(spacing: 5) {
                            Text(viewmodel.updateDateString())
                                .font(.title2.weight(.semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.8, blue: 0.4))
                            
                            HStack(spacing: 5) {
                                Text("🔥")
                                Text("\(viewmodel.globalStreak) \(viewmodel.globalStreak == 1 ? "day" : "days") Streak")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                        }
                        .multilineTextAlignment(.center)
                        
                        // Horizontal Date Selector (No Scroll, Centered)
                        HStack(spacing: 15) {
                            ForEach(generateWeekDates(), id: \.self) { day in
                                let todayString = viewmodel.updateDateString().prefix(2)
                                let isToday = day.hasPrefix(todayString)
                                
                                Text(day)
                                    .font(.subheadline.weight(isToday ? .bold : .regular))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(isToday ? .white : .white.opacity(0.7))
                                    .padding(.vertical, isToday ? 8 : 0)
                                    .padding(.horizontal, isToday ? 10 : 0)
                                    .background(
                                        isToday ?
                                        Color(red: 1.0, green: 0.4, blue: 0.3)
                                            .cornerRadius(15)
                                            .shadow(color: Color(red: 1.0, green: 0.4, blue: 0.3, opacity: 0.5), radius: 5, x: 0, y: 2)
                                        : nil
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(red: 0.13, green: 0.13, blue: 0.17),
                            Color(red: 0.09, green: 0.09, blue: 0.13).opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                    
                    // HABIT LIST
                    if viewmodel.habits.isEmpty {
                        Text("No habits yet. Add a new one to get started!")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewmodel.habits) { habit in
                                HabitButtonView(habit: habit, isEditMode: $isEditMode)
                                    .background(Color(red: 0.13, green: 0.13, blue: 0.17))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    // Add extra bottom padding so content doesn't get covered by bottom buttons
                    Spacer(minLength: 100)
                }
                .padding(.bottom, 180) // Increase this if needed for more spacing
            }
            
            // Bottom Buttons
            VStack {
                Spacer()
                
                Button(action: {
                    showHabitForm.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Circle())
                        .shadow(color: Color.orange.opacity(0.6), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 15)
                
                NavigationLink(destination: ChartsView()) {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 20))
                        Text("View Charts")
                            .foregroundColor(.orange)
                            .font(.headline)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.13, green: 0.13, blue: 0.17))
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.bottom, 30)
            }
            .sheet(isPresented: $showHabitForm,
                   onDismiss: viewmodel.onAddHabitDismissed) {
                AddHabitView()
                    .presentationDragIndicator(.visible)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditMode ? "Done" : "Edit") {
                        isEditMode.toggle()
                        viewmodel.refreshHabits()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            randomizeMotivationalQuote()
            startMotivationalQuoteTimer()
        }
    }
    
    // Timer-based quote refresh
    private func startMotivationalQuoteTimer() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            randomizeMotivationalQuote()
        }
    }
}

#Preview {
    HabitListView()
}
