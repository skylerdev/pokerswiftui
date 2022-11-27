//
//  CardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(card.toIcon())
                .font(.custom("Courier", size: 200))
                .opacity(0.40)
                .offset(x:20)
                .padding(.bottom, -60)
                .padding(.horizontal, -10)
            
            Text(card.displayRank())
                    .bold()
                    .font(.custom("appleSDGothicNeo-Regular", size: 20))
                    .dynamicTypeSize(.accessibility4)
                    .padding(.all, 3)
                    .padding(.horizontal, 5)
                    .foregroundColor(card.suit == .heart || card.suit == .diamond ? .primary : .black.opacity(0.0))
                    .colorInvert()
                    .offset(x:1, y:1)
            
            Text(card.displayRank())
                    .bold()
                    .font(.custom("AppleSDGothicNeo-Regular", size: 20))
                    .dynamicTypeSize(.accessibility4)
                    .padding(.all, 3)
                    .padding(.horizontal, 5)
                    .foregroundColor(card.suit == .heart || card.suit == .diamond ? .red : .primary)
            

        }
        .foregroundColor(
            card.suit == .heart || card.suit == .diamond ? .red : .primary
        )
        .frame(width: 100, height: 140, alignment: .topLeading)
        .background(.ultraThickMaterial)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(.gray, lineWidth: 1)
            )
        
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

    }
}
