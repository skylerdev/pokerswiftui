//
//  HostButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-17.
//

import SwiftUI

struct HostButton: View {
    var color: Color
    var text: String
    
    var body: some View {
        Text(text)
            .padding(10)
            .background(color)
            .foregroundColor(.accentColor)
            .cornerRadius(10)
         //   .opacity(<#T##opacity: Double##Double#>)
    }
}

struct HostButton_Previews: PreviewProvider {
    static var previews: some View {
        HostButton(color: .red, text: "Fuck")
    }
}
