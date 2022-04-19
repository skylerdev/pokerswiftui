//
//  JoinButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-17.
//

import SwiftUI

struct JoinButton: View {
    var body: some View {
        Button(action: joinPressed) {
            Text("Join")
        }
        .background(.cyan)
    }
    
    
    func joinPressed(){
        print("Pressed join")
        
    }
    
}

struct JoinButton_Previews: PreviewProvider {
    static var previews: some View {
        JoinButton()
    }
}
