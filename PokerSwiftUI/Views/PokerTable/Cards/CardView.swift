//
//  CardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var x = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Text(card.rank.rawValue)
                .bold()
                .font(.body)
            
            Image(systemName: "suit.\(card.suit.rawValue).fill")
                .resizable()
                .opacity(0.40)
                .scaledToFit()
                .offset(x: card.suit == .diamond ? 16 : 10)
                .padding(.top, 23)
            
        }
        .foregroundColor(
            card.suit == .heart || card.suit == .diamond ? .red : .black
        )
        .frame(width: 30, height: 50, alignment: .topLeading)
        .background(.ultraThickMaterial)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: Card(suit: .diamond, rank: .jack) )
            CardView(card: Card(suit: .club, rank: .six) )
            CardView(card: Card(suit: .spade, rank: .ten) )
            CardView(card: Card(suit: .heart, rank: .two))
        }
        .previewLayout(.sizeThatFits)
    }
}
