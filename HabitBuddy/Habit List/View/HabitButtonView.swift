//
//  HabitButtonView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import SwiftUI

struct HabitButtonView: View {
    
    @ObservedObject var viewModel: HabitButtonViewModel
    @Binding var isEditMode: Bool
    
    init(habit: Habit, isEditMode: Binding<Bool>) {
        viewModel = HabitButtonViewModel(habit: habit)
        self._isEditMode = isEditMode
    }
    
    var body: some View {
        if !viewModel.isDeleted {
            // Determine if habit is completed today and not in edit mode
            let isCompleted = viewModel.isLastDateSameAsToday() && !isEditMode
            
            // Choose accent color based on completion
            // Green for completed (like the "Silence" card in image), orange if not completed.
            let accentColor = isCompleted
                ? Color(red: 0.6, green: 0.8, blue: 0.4) // Green accent
                : Color(red: 1.0, green: 0.4, blue: 0.3) // Orange accent
            
            Button(action: {
                viewModel.buttonHabitClicked()
            }) {
                HStack(alignment: .center, spacing: 15) {
                    // Emoji (Large Icon)
                    Text(viewModel.habit.emoji)
                        .font(.system(size: 50))
                        .padding(.leading, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        // Title with accent color
                        Text(viewModel.habit.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(accentColor)
                        
                        // Description
                        Text(viewModel.habit.description)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Streak info
                        Text("\(viewModel.habit.streak) \(viewModel.habit.streak == 1 ? "day" : "days") Streak")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // Checkmark if completed
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(accentColor)
                            .padding(.trailing, 10)
                    }
                    
                    // Edit mode delete button
                    if isEditMode && !viewModel.isDeleted {
                        Button(action: {
                            viewModel.deleteHabit()
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding()
                // Dark card background to match the image’s style
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                )
                // If completed, show a border similar to the example image
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isCompleted ? accentColor : Color.clear, lineWidth: 2)
                )
            }
            .disabled(isCompleted) // Same logic as before
        }
    }
}

#Preview {
    HabitButtonView(habit: DeveloperPreview.habits[0], isEditMode: .constant(false))
}
