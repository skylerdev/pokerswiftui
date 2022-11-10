//
//  YourCardsView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableCardsView: View {
    var card1: Card
    var card2: Card
    var card3: Card
    var card4: Card
    var card5: Card
    var stage: GamePhase
    
    var body: some View {
        VStack {
            CardView(card: card1)
                .padding(.all, 2)
            CardView(card: card2)
                .padding(.all, 2)
            CardView(card: card3)
                .padding(.all, 2)
            CardView(card: card4)
                .padding(.all, 2)
            CardView(card: card5)
                .padding(.all, 2)
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
        TableCardsView(card1: Card(suit: .club, rank: .nine), card2: Card(suit: .spade, rank: .king)
                       , card3: Card(suit: .heart, rank: .two), card4: Card(suit: .spade, rank: .queen), card5: Card(suit: .diamond, rank: .ten), stage: .flop)
            .previewLayout(.sizeThatFits)
    }
}
