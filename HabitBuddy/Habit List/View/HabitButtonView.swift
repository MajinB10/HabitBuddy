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
        if (!viewModel.isDeleted) {
            
            Button(action: {
                viewModel.buttonHabitClicked()
            },
                   label: {
                HStack (alignment: .center, spacing: 15) {
                    // Emoji
                    Text(viewModel.habit.emoji)
                        .font(Font.system(size: 60))
                        .padding(.leading)
                    
                    // Habit Description (title, description, streak)
                    VStack (alignment: .leading) {
                        Text(viewModel.habit.title)
                            .foregroundStyle(.orange)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Text(viewModel.habit.description)
                            .foregroundStyle(Color(.label))
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Text("\(viewModel.habit.streak) \(viewModel.habit.streak == 1 ? "day" : "days") Streak")
                            .foregroundStyle(Color(.label))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    
                    
                    // Checkmark Symbol
                    if (viewModel.isLastDateSameAsToday() && !isEditMode) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(Font.system(size: 50))
                            .foregroundStyle(.orange)
                            .padding(.trailing)
                    } else {
                        //                    Image(systemName: "circle")
                        //                        .font(Font.system(size: 50))
                        //                        .foregroundStyle(.orange)
                        //                        .padding(.trailing)
                    }
                    
                    if (isEditMode && !viewModel.isDeleted) {
                        Button(action: {
                            viewModel.deleteHabit()
                        } ,label:{
                            Image(systemName: "minus.circle.fill")
                                .font(Font.system(size: 50))
                                .foregroundStyle(.red)
                                .padding(.trailing)
                        })
                        
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .shadow(color: Color(.systemGray),radius: 3)
            }
            )
            .disabled(viewModel.isLastDateSameAsToday() && !isEditMode)
        }
    }
}

#Preview {
    HabitButtonView(habit: DeveloperPreview.habits[0], isEditMode: .constant(true))
}
