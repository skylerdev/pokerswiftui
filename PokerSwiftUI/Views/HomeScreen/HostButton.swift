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
    
    var body: some View {
        Button {
            pressed()
        } label: {
            Text(text)
                .foregroundColor(.accentColor)
        }
        .padding(valid ? 30 : 10)
        .background(valid ? .green : .red )
        .opacity(valid ? 1 : 0.15)
        .cornerRadius(10)
        .animation(.spring(), value: valid)
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
