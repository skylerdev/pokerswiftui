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
                    .dynamicTypeSize(.accessibility1)
                    .padding(.horizontal, 3)
            }
            
            Text(card.toIcon())
                .font(.custom("Courier", size: 100))
                .opacity(0.40)
                .offset(x: 10, y: -25)
        }
        .foregroundColor(
            card.suit == .heart || card.suit == .diamond ? .red : .black
        )
        .frame(width: 50, height: 70, alignment: .topLeading)
        .background(.ultraThickMaterial)
        .cornerRadius(4)
        
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
