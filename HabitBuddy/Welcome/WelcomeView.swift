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
    
    @State private var isGlowing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(red: 0.09, green: 0.09, blue: 0.13)
                    .ignoresSafeArea()
                
                // Abstract Shapes
                ZStack {
                    // Red circle top-left
                    Circle()
                        .fill(Color(red: 0.95, green: 0.4, blue: 0.35))
                        .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                        .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.4)
                        .blur(radius: 20)
                    
                    // Green circle middle
                    Circle()
                        .fill(Color(red: 0.6, green: 0.8, blue: 0.4))
                        .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                        .offset(x: screenWidth * 0.4, y: -screenHeight * 0.1)
                        .blur(radius: 20)
                    
                    // Blue circle bottom-left
                    Circle()
                        .fill(Color(red: 0.3, green: 0.6, blue: 0.9))
                        .frame(width: screenWidth * 0.9, height: screenWidth * 0.9)
                        .offset(x: -screenWidth * 0.35, y: screenHeight * 0.3)
                        .blur(radius: 20)
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Title
                    Text("HabitBuddy")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        // Glowing magenta effect
                        .shadow(color: Color(red: 1.0, green: 0.0, blue: 1.0).opacity(isGlowing ? 1.0 : 0.3),
                                radius: isGlowing ? 40 : 5, x: 0, y: 0)
                        .shadow(color: Color(red: 1.0, green: 0.0, blue: 1.0).opacity(isGlowing ? 0.7 : 0),
                                radius: isGlowing ? 80 : 0, x: 0, y: 0)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                isGlowing = true
                            }
                        }
                    
                    // Subtitle
                    Text("Stay Motivated Stay Consistent")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Get Started Button (no animation, direct navigation)
                    NavigationLink(destination: HabitListView().navigationBarBackButtonHidden(true)) {
                        Text("Get started")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical, 15)
                            .padding(.horizontal, 50)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                            .cornerRadius(10)
                    }
                    
                    // Page Indicator
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 25, height: 8)
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
