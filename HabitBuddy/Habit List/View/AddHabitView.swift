//
//  AddHabitView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 9/12/24.
//

import SwiftUI

struct AddHabitView: View {
    
    @StateObject var viewModel = AddHabitViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var animateCircles = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            // Animated Circles
            ZStack {
                // Red circle top-left
                Circle()
                    .fill(Color(red: 0.95, green: 0.4, blue: 0.35))
                    .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                    .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.4)
                    .blur(radius: 20)
                    .scaleEffect(animateCircles ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateCircles)
                
                // Green circle middle-right
                Circle()
                    .fill(Color(red: 0.6, green: 0.8, blue: 0.4))
                    .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                    .offset(x: screenWidth * 0.4, y: -screenHeight * 0.1)
                    .blur(radius: 20)
                    .scaleEffect(animateCircles ? 0.95 : 1.05)
                    .animation(.easeInOut(duration: 3).delay(1).repeatForever(autoreverses: true), value: animateCircles)
                
                // Blue circle bottom-left
                Circle()
                    .fill(Color(red: 0.3, green: 0.6, blue: 0.9))
                    .frame(width: screenWidth * 0.9, height: screenWidth * 0.9)
                    .offset(x: -screenWidth * 0.35, y: screenHeight * 0.3)
                    .blur(radius: 20)
                    .scaleEffect(animateCircles ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 3).delay(2).repeatForever(autoreverses: true), value: animateCircles)
            }
            .onAppear {
                animateCircles = true
            }
            
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                // Emoji Picker
                TextField("👋🏼", text: $viewModel.emoji.max(1))
                    .font(.system(size: 60))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                    )
                    .frame(width: 100)
                    .padding(.top, 50)
                
                // Title field with custom placeholder
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.title.max(25))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                        )

                    if viewModel.title.isEmpty {
                        Text("Title")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // Bright placeholder for better visibility
                            .padding(.leading, 14)
                    }
                }
                
                // Description field with custom placeholder
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.description.max(70), axis: .vertical)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                        )
                        .multilineTextAlignment(.leading)

                    if viewModel.description.isEmpty {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white) // Bright placeholder
                            .padding(.leading, 14)
                    }
                                    }
                
                // Error Message
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .foregroundColor(.red)
                }
                
                // Add Button
                Button(action: {
                    if viewModel.addNewHabit() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Add")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 50)
                        .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

// Max character extension for TextFields
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

#Preview {
    AddHabitView()
}
