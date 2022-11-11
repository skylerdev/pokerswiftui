//
//  HostButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-17.
//

import SwiftUI

struct HostButton: View {
    var pressed: () -> Void
    var valid: Bool
    var text: String
    let shadowcolor = Color(.sRGBLinear, white: 0, opacity: 0.5)
    
    var body: some View {
        Button {
            pressed()
        } label: {
            Text(text)
                .foregroundColor(valid ? .accentColor : .secondary)
                .animation(.easeInOut, value: valid)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
        }
        .buttonStyle(.bordered)
        .padding(.vertical)
//        .padding()
//        .background(.regularMaterial)
//        .cornerRadius(10)
//        .shadow(color: shadowcolor, radius: valid ? 2 : 0, x: valid ? 2 : 0, y: valid ? 2 : 0)
        .animation(.easeInOut, value: valid)
        .disabled(!valid)
    }
}

struct HostButton_Previews: PreviewProvider {
    static var previews: some View {
        HostButton(pressed: {
            print("pressed")
        }, valid: true, text: "Hi")
    }
}
