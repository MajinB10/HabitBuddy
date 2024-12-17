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
    @State private var animateRedCircle = false
    @State private var animateGreenCircle = false
    @State private var animateBlueCircle = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.09, green: 0.09, blue: 0.13),
                        Color(red: 0.05, green: 0.05, blue: 0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Animated Circles
                ZStack {
                    // Red circle top-left
                    Circle()
                        .fill(Color(red: 0.95, green: 0.4, blue: 0.35).opacity(0.4))
                        .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                        .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.4)
                        .blur(radius: 30)
                        .scaleEffect(animateRedCircle ? 1.1 : 0.9)
                        .rotationEffect(.degrees(animateRedCircle ? 10 : -10))
                    
                    // Green circle middle
                    Circle()
                        .fill(Color(red: 0.6, green: 0.8, blue: 0.4).opacity(0.4))
                        .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                        .offset(x: screenWidth * 0.4, y: -screenHeight * 0.1)
                        .blur(radius: 30)
                        .scaleEffect(animateGreenCircle ? 1.05 : 0.95)
                        .rotationEffect(.degrees(animateGreenCircle ? -15 : 15))
                    
                    // Blue circle bottom-left
                    Circle()
                        .fill(Color(red: 0.3, green: 0.6, blue: 0.9).opacity(0.4))
                        .frame(width: screenWidth * 0.9, height: screenWidth * 0.9)
                        .offset(x: -screenWidth * 0.35, y: screenHeight * 0.3)
                        .blur(radius: 30)
                        .scaleEffect(animateBlueCircle ? 1.2 : 1.0)
                        .rotationEffect(.degrees(animateBlueCircle ? 20 : -20))
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateRedCircle = true
                    }
                    withAnimation(Animation.easeInOut(duration: 3.5).repeatForever(autoreverses: true).delay(0.5)) {
                        animateGreenCircle = true
                    }
                    withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1)) {
                        animateBlueCircle = true
                    }
                }
                
                // Overlay gradient to unify the background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Title
                    Text("HabitBuddy")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .white.opacity(isGlowing ? 0.6 : 0.2),
                                radius: isGlowing ? 20 : 5, x: 0, y: 0)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                isGlowing = true
                            }
                        }
                    
                    // Subtitle
                    Text("Stay Motivated. Stay Consistent.")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Get Started Button
                    NavigationLink(destination: HabitListView().navigationBarBackButtonHidden(true)) {
                        Text("Get started")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.vertical, 15)
                            .padding(.horizontal, 50)
                            .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                            .cornerRadius(12)
                            .shadow(color: Color(red: 1.0, green: 0.4, blue: 0.3, opacity: 0.6), radius: 8, x: 0, y: 4)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
