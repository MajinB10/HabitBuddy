//
//  HabitListView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 3/12/24.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var viewmodel = HabitListViewModel()
    @State var showHabitForm = false
    
    var body: some View {
        ScrollView {
            
            VStack (alignment: .leading, spacing: 30) {
                // Motivational Header
                Text("Dont forget what made you start this!\nYou can get through It!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                VStack (alignment: .leading, spacing: 5) {
                    // Today's Date
                    Text(viewmodel.updateDateString())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.cyan)
                    
                    //List Streak
                    Text("🔥 1 Day Streak")
                        .font(.title3)
                }
                
                
                // Habit List
                // Button
                
                LazyVStack (spacing: 20) {
                    ForEach(viewmodel.habits) { habit in
                        
                        HabitButtonView(habit: habit)
                        
                    }
                }
                
                
                
                
                
                
                //Add Habit Button
                HStack{
                    Spacer()
                    
                    Button(action: {
                        showHabitForm.toggle()
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
        .sheet(isPresented: $showHabitForm, content: {
            AddHabitView()
                .presentationDragIndicator(.visible)
        })
    }
}
#Preview {
    HabitListView()
}
