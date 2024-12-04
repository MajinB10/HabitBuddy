//
//  ContentView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 3/12/24.
//

import SwiftUI

struct WelcomeView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Background
            ZStack {
                Circle()
                    .foregroundStyle(.cyan)
                    .frame(width: screenWidth / 1.4)
                    .offset(x: -screenWidth / 2,
                            y: -screenHeight / 2)
                Circle()
                    .foregroundStyle(.green)
                    .frame(width: screenWidth / 1)
                    .offset(x: screenWidth / 3,
                            y: screenHeight / 3)
                Circle()
                    .foregroundStyle(.yellow)
                    .frame(width: screenWidth / 1.7)
                    .offset(x: screenWidth / 3,
                            y: -screenHeight / 4)
            }
            
            // Content
            VStack (alignment: .leading, spacing: 15) {
                // Title
                Text("HabitBuddy")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                
                //Slogan
                Text("Stay Motivated, Stay Consistent")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                //Get Started Button
                Button(action: {
                    
                }, label: {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .background(.orange)
                        .cornerRadius(10)
                })
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
