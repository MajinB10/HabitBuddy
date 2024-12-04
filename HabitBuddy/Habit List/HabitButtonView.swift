//
//  HabitButtonView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import SwiftUI

struct HabitButtonView: View {
    var body: some View {
        @StateObject var habit = HabitListViewModel().habits
        
        Button(action: {
            
        },
               label: {
            HStack (alignment: .center, spacing: 15) {
                // Emoji
                Text(habit.emoji)
                    .font(Font.system(size: 60))
                    .padding(.leading)
                
                // Habit Description (title, description, streak)
                VStack (alignment: .leading) {
                    Text("Habit Title")
                        .foregroundStyle(.orange)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Habit Description")
                        .foregroundStyle(Color(.label))
                        .font(.subheadline)
                    Text("1 Day Streak")
                        .foregroundStyle(Color(.label))
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Checkmark Symbol
                Image(systemName: "checkmark.circle.fill")
                    .font(Font.system(size: 50))
                    .foregroundStyle(.orange)
                    .padding(.trailing)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color(.systemGray),radius: 3)
        })    }
}

#Preview {
    HabitButtonView()
}
