//
//  YourCardsView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableCardsView: View {
    var cards: [Card]
    var stage: GamePhase
    
    var body: some View {
        VStack {
            ForEach(cards, id: \.self){ card in
                CardView(card: card)
                    .padding(2)
            }
        }
        
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
        .background(.black.opacity(0.2))
        .cornerRadius(16)
        .scaleEffect(0.9)
        
    }
}

struct TableCardsView_Previews: PreviewProvider {
    static var previews: some View {
        TableCardsView(cards: [Card(suit: .heart, rank: .ace), Card(suit: .spade, rank: .five), Card(suit: .spade, rank: .ace), Card(suit: .heart, rank: .nine), Card(suit: .heart, rank: .jack)], stage: .flop)
            .previewLayout(.sizeThatFits)
    }
}
