//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 3/12/24.
//

import SwiftUI

struct HabitListView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 30) {
            // Motivational Header
            Text("Dont forget what made you start this!\nYou can get through It!")
                .font(.title)
                .fontWeight(.bold)
            
            VStack (alignment: .leading, spacing: 5) {
                // Today's Date
                Text("December 3rd, 2024")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.cyan)
                
                //List Streak
                Text("🔥 1 Day Streak")
                    .font(.title3)
            }
            
            
            // Habit List
            // Button
            Button(action: {
                
            },
            label: {
                HStack (alignment: .center, spacing: 15) {
                    // Emoji
                    Text("🧘🏼‍♀️")
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
            })

            
            
            //Add Habit Button
            HStack{
                Spacer()
                
                Button(action: {
                    
                },
                label: {
                    Image(systemName: "plus.circle.fill")
                        .font(Font.system(size: 50))
                        .foregroundStyle(.orange)
                })
            }
            
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HabitListView()
}
