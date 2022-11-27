//
//  CardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct MiniCardView: View {
    var cards: [Card]
    var showing: Bool
    
    var body: some View {
        VStack (alignment: .trailing) {
            ForEach(cards, id: \.self){ card in
                Text(card.displayRank() + card.toIcon() + " ")
                    .padding(.vertical, 3)
                    .padding(.leading, 50)
                    .background(.thickMaterial)
                    .cornerRadius(4)

                
                    .foregroundColor(card.suit == .heart || card.suit == .diamond ? .red : .primary)
                    .padding(.bottom, -4)
                    .padding(.leading, -40)
                    .opacity(showing ? 1 : 0)
                    
            }
            

        }
        .padding(.top, -10)
    }
}

struct MiniCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardView(cards: Array(repeating: Card(suit: .diamond, rank: .ten), count: 2), showing: false)

    }
}
