//
//  ShowButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-11-28.
//

import SwiftUI

struct ShowButton: View {
    var action: () -> Void
    
    var body: some View {
            Button {
                action()
            } label: {
                    Text("Show")
            }
            
            
    }
}

struct ShowButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowButton {
            print("hi")
        }
    }
}
