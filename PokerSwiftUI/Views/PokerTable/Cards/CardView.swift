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
        VStack(alignment: .leading) {
            
            HStack {
                Text(card.rank.rawValue)
                    .bold()
                    .font(.body)
                    .dynamicTypeSize(.accessibility4)
                    .padding(.horizontal, 6)
            }
            
            Text(card.toIcon())
                .font(.custom("Courier", size: 200))
                .opacity(0.40)
                .offset(x: 20, y: -50)
        }
        .foregroundColor(
            card.suit == .heart || card.suit == .diamond ? .red : .black
        )
        .frame(width: 100, height: 140, alignment: .topLeading)
        .background(.ultraThickMaterial)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(.gray, lineWidth: 1)
            .opacity(0.4))
        
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
