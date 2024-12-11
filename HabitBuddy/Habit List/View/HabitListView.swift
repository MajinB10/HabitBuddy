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

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Motivational Header
                    Text("Small Habits, Big Changes ✨")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    // Date & Streak section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewmodel.updateDateString()) // dynamic date
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
                            ForEach(["13\nMon", "14\nTues", "15\nWed", "16\nThurs", "17\nFri", "18\nSat", "19\nSun"], id: \.self) { day in
                                VStack {
                                    if day.contains("15") {
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
                    
                    // Add Habit Button (Centered)
                    Button(action: {
                        showHabitForm.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(Font.system(size: 50))
                            .foregroundStyle(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
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
    }
}

#Preview {
    HabitListView()
}
