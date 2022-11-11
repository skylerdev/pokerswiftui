//
//  CardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct MiniCardView: View {
    var cards: [Card]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(cards: Array(repeating: Card(suit: .diamond, rank: .jack), count: 2))

    }
}
