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
    @State private var currentMotivationalQuote: String = "" // For random motivational headers
    @State private var animateHeader: Bool = false // State variable for animation

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
    
    // Helper function to generate dates for the current week (Monday to Sunday)
    func generateWeekDates() -> [String] {
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd\nEEE" // Format as "15\nWed"
        
        // Find the start of the week (Monday)
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: weekStart) {
                return formatter.string(from: date)
            }
            return nil
        }
    }
    
    // Function to randomize the motivational header
    private func randomizeMotivationalQuote() {
        if let randomQuote = motivationalQuotes.randomElement() {
            currentMotivationalQuote = randomQuote
            animateHeader = false // Reset animation state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateHeader = true // Trigger animation
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Motivational Header with Animation
                    Text(currentMotivationalQuote)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .opacity(animateHeader ? 1.0 : 0.0) // Fade-in effect
                        .scaleEffect(animateHeader ? 1.0 : 0.8) // Scaling effect
                        .animation(.spring(response: 0.5, dampingFraction: 0.5), value: animateHeader)
                    
                    // Date & Streak section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewmodel.updateDateString()) // Dynamic date
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.6, green: 0.8, blue: 0.4))
                        
                        HStack(spacing: 5) {
                            Text("🔥")
                            Text("\(viewmodel.globalStreak) \(viewmodel.globalStreak == 1 ? "day" : "days") Streak")
                                .foregroundColor(.white)
                                .font(.body)
                        }
                    }
                    
                    // Horizontal Date Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(generateWeekDates(), id: \.self) { day in
                                VStack {
                                    // Highlight the current date
                                    if day.contains(viewmodel.updateDateString().prefix(2)) {
                                        Text(day)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                                            .cornerRadius(20)
                                    } else {
                                        Text(day)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    // Habit List
                    LazyVStack(spacing: 20) {
                        ForEach(viewmodel.habits) { habit in
                            HabitButtonView(habit: habit, isEditMode: $isEditMode)
                        }
                    }
                }
                .padding()
            }
            
            VStack {
                Spacer()
                
                // Add Habit Button
                Button(action: {
                    showHabitForm.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(Font.system(size: 50))
                        .foregroundStyle(.orange)
                }
                .padding(.bottom, 10)
                
                // Charts Navigation Button
                NavigationLink(destination: ChartsView()) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 20))
                        Text("View Charts")
                            .foregroundColor(.orange)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(red: 0.13, green: 0.13, blue: 0.17))
                    .cornerRadius(15)
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
            randomizeMotivationalQuote() // Set initial motivational header
            startMotivationalQuoteTimer() // Start periodic updates
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
