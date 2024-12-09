//
//  AddHabitView.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 9/12/24.
//

import SwiftUI

struct AddHabitView: View {
    
    @State var emoji: String = ""
    @State var title: String = ""
    @State var description: String = ""

    
    var body: some View {
        VStack (alignment: .center, spacing: 20) {
            // Emoji Picker
            TextField("👋🏼", text: $emoji.max(1))
                .frame(width: 65)
                .font(.system(size: 60))
                .padding(.top, 30)
            
            // Title
            TextField("Title", text: $title.max(25))
                .font(.title)
                .fontWeight(.bold)

            // Description
            TextField("Description", text: $description.max(70), axis: .vertical)
                .font(.title2)
                .multilineTextAlignment(.leading)

            
            // Add Button
            Button(action:{
                
            } ,
                   label: {
                Text("Add")
                    .foregroundColor(.white)
                    .padding()
                    .fontWeight(.bold)
                    .background(.orange)
                    .cornerRadius(10)
            })
            Spacer()
        }
        .padding()
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


#Preview {
    AddHabitView()
}
