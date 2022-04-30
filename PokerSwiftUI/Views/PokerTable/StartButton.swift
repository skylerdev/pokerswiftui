//
//  StartButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-22.
//

import SwiftUI

struct StartButton: View {
    var action: () -> Void
    
    var body: some View {
            Button {
                action()
            } label: {
                    Text("Start")
            }
            
            
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton {
            print("hi")
        }
    }
}
