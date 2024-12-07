//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 3/12/24.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var viewmodel = HabitListViewModel()
    
    var body: some View {
        ScrollView {
            
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
            
            LazyVStack {
                ForEach(viewmodel.habits) { habit in
                    
                    HabitButtonView()
                    
                }
            }
            
            
            
            
            
            
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
}

#Preview {
    HabitListView()
}
