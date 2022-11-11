//
//  YourCardsView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableCardsView: View {
    var cards: [Card]
    
    var body: some View {
        VStack (alignment: .leading){
            ForEach(cards, id: \.self){ card in
                CardView(card: card)
                    .padding(2)
            }
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .frame(maxHeight: .infinity)
        .frame(minWidth: 140)
        .background(.black.opacity(0.2))
        .cornerRadius(16)
        .scaleEffect(0.9)
        
    }
}

struct TableCardsView_Previews: PreviewProvider {
    static var previews: some View {
        TableCardsView(cards: [Card(suit: .heart, rank: .ace), Card(suit: .spade, rank: .five), Card(suit: .spade, rank: .ace), Card(suit: .heart, rank: .nine), Card(suit: .heart, rank: .jack)])
            .previewLayout(.sizeThatFits)
    }
}
