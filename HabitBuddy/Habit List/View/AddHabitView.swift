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
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String = "👋🏼" // Temporary state for emoji selection
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.09, green: 0.09, blue: 0.13)
                .ignoresSafeArea()
            
            // Animated Circles
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.4, blue: 0.35))
                    .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                    .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.4)
                    .blur(radius: 20)
                    .scaleEffect(animateCircles ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateCircles)
                
                Circle()
                    .fill(Color(red: 0.6, green: 0.8, blue: 0.4))
                    .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                    .offset(x: screenWidth * 0.4, y: -screenHeight * 0.1)
                    .blur(radius: 20)
                    .scaleEffect(animateCircles ? 0.95 : 1.05)
                    .animation(.easeInOut(duration: 3).delay(1).repeatForever(autoreverses: true), value: animateCircles)
                
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
                
                // Emoji Display
                Button(action: {
                    showEmojiPicker = true // Show emoji picker on button tap
                }) {
                    Text(selectedEmoji)
                        .font(.system(size: 60))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                        )
                        .frame(width: 100)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                }
                .sheet(isPresented: $showEmojiPicker) {
                    EmojiPickerView(selectedEmoji: $selectedEmoji)
                        .onDisappear {
                            viewModel.emoji = selectedEmoji // Finalize emoji selection
                        }
                }
                
                // Title Field
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
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.leading, 14)
                    }
                }
                
                // Description Field
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
                            .foregroundColor(.white.opacity(0.6))
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

// Emoji Picker View
struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    let emojiOptions = [
        "👋🏼", "🔥", "🌟", "✅", "💪", "📚", "🎯", "💼", "🧘", "🏃‍♂️",
        "🎉", "❤️", "🙌", "😎", "👍", "🥳", "✨", "🌈", "🍀", "🎵"
    ]
    @Environment(\.dismiss) private var dismiss // For dismissing the sheet
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark Background
                Color(red: 0.09, green: 0.09, blue: 0.13)
                    .ignoresSafeArea()
                
                ScrollView {
                    Text("Pick an Emoji")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity ,alignment: .leading)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding()
                                .background(selectedEmoji == emoji ? Color.orange : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedEmoji = emoji // Update the selected emoji
                                    dismiss() // Dismiss the sheet after selection
                                }
                        }
                    }
                    .padding()
                }
            }
//            .navigationTitle("Pick an Emoji")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss() // Allow manual dismissal
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}


#Preview {
    AddHabitView()
}
