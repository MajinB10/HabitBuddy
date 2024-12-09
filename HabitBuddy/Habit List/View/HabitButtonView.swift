//
//  HabitButtonView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import SwiftUI

struct HabitButtonView: View {
    
    @ObservedObject var viewModel: HabitButtonViewModel
    
    init(habit: Habit) {
        viewModel = HabitButtonViewModel(habit: habit)
    }
    
    var body: some View {
        
        
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
                    Text(viewModel.habit.description)
                        .foregroundStyle(Color(.label))
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Text("\(viewModel.habit.streak) Day Streak")
                        .foregroundStyle(Color(.label))
                        .font(.subheadline)
                }
                
                Spacer()
                
                
                
                // Checkmark Symbol
                if (viewModel.habit.isDone) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(Font.system(size: 50))
                        .foregroundStyle(.orange)
                        .padding(.trailing)
                } else {
                    Image(systemName: "circle")
                        .font(Font.system(size: 50))
                        .foregroundStyle(.orange)
                        .padding(.trailing)
                }
                
                
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color(.systemGray),radius: 3)
        })    }
}

#Preview {
    HabitButtonView(habit: DeveloperPreview.habits[0])
}
