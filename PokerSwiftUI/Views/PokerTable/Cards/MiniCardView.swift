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
        HStack {
            Text(cards[0].rank.rawValue + cards[0].toIcon())
                .padding(.vertical, 2)
                .frame(minWidth: 40)
                .padding(.bottom, 20)
                .background(.thinMaterial)
                .cornerRadius(2)
            Text(cards[1].rank.rawValue + cards[1].toIcon())
                .padding(.vertical, 2)
                .frame(minWidth: 40)
                .padding(.bottom, 20)
                .background(.thinMaterial)
                .cornerRadius(2)
        }
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(cards: Array(repeating: Card(suit: .diamond, rank: .ten), count: 2))

    }
}
