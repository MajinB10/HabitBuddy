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
    @State private var selectedEmoji: String = "👋🏼"
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // Background with a subtle gradient and softened circles
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.09, green: 0.09, blue: 0.13),
                Color(red: 0.05, green: 0.05, blue: 0.1)
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            // Subtle animated circles
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.4, blue: 0.35).opacity(0.3))
                    .frame(width: screenWidth * 0.7, height: screenWidth * 0.7)
                    .offset(x: -screenWidth * 0.3, y: -screenHeight * 0.35)
                    .blur(radius: 40)
                    .scaleEffect(animateCircles ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateCircles)
                
                Circle()
                    .fill(Color(red: 0.6, green: 0.8, blue: 0.4).opacity(0.3))
                    .frame(width: screenWidth * 0.5, height: screenWidth * 0.5)
                    .offset(x: screenWidth * 0.4, y: -screenHeight * 0.15)
                    .blur(radius: 40)
                    .scaleEffect(animateCircles ? 0.95 : 1.05)
                    .animation(.easeInOut(duration: 3).delay(1).repeatForever(autoreverses: true), value: animateCircles)
                
                Circle()
                    .fill(Color(red: 0.3, green: 0.6, blue: 0.9).opacity(0.3))
                    .frame(width: screenWidth * 0.8, height: screenWidth * 0.8)
                    .offset(x: -screenWidth * 0.2, y: screenHeight * 0.3)
                    .blur(radius: 40)
                    .scaleEffect(animateCircles ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 3).delay(2).repeatForever(autoreverses: true), value: animateCircles)
            }
            .onAppear {
                animateCircles = true
            }
            
            VStack(spacing: 20) {
                // Top Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                
                Spacer(minLength: 20)
                
                // Title
                Text("Add New Habit")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                // Emoji Selector
                Button(action: {
                    showEmojiPicker = true
                }) {
                    VStack {
                        Text(selectedEmoji)
                            .font(.system(size: 50))
                        
                        Text("Select Emoji")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
                    )
                }
                .sheet(isPresented: $showEmojiPicker) {
                    EmojiPickerView(selectedEmoji: $selectedEmoji)
                        .onDisappear {
                            viewModel.emoji = selectedEmoji
                        }
                }
                
                // Input Fields
                VStack(spacing: 15) {
                    // Title Field
                    HStack {
                        Image(systemName: "textformat")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("", text: $viewModel.title.max(25))
                            .foregroundColor(.white)
                            .placeholder(when: viewModel.title.isEmpty) {
                                Text("Title").foregroundColor(.white.opacity(0.6))
                            }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.13, green: 0.13, blue: 0.17)))
                    
                    // Description Field
                    HStack(alignment: .top) {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 10)
                        TextField("", text: $viewModel.description.max(70), axis: .vertical)
                            .foregroundColor(.white)
                            .placeholder(when: viewModel.description.isEmpty) {
                                Text("Description").foregroundColor(.white.opacity(0.6))
                            }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.13, green: 0.13, blue: 0.17)))
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
                    HStack(spacing: 5) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                        Text("Add")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(Color(red: 1.0, green: 0.4, blue: 0.3))
                    .cornerRadius(12)
                    .shadow(color: Color(red: 1.0, green: 0.4, blue: 0.3, opacity: 0.5), radius: 5, x: 0, y: 2)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

// Helper to show placeholders in TextFields
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            self
            if shouldShow {
                placeholder().padding(.leading, 2)
            }
        }
    }
}

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
    @Environment(\.dismiss) private var dismiss
    
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
                        .padding(.top)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding()
                                .background(selectedEmoji == emoji ? Color.orange : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedEmoji = emoji
                                    dismiss()
                                }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
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
