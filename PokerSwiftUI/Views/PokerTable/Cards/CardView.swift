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
        VStack(alignment: .trailing) {
            
            HStack {
                Text(card.rank.rawValue)
                    .bold()
                    .font(.body)
                    .padding(.leading, 1)
                Spacer()
            }.padding(.top, -2)
           
          
                Spacer()
                Image(systemName: "suit.\(card.suit.rawValue).fill")
                    .opacity(0.40)
                    .scaledToFill()
                    .scaleEffect(1.5, anchor: .bottomTrailing)
                    
                    
            
                
            
        }
        .foregroundColor(
            card.suit == .heart || card.suit == .diamond ? .red : .black
        )
        .frame(width: 30, height: 50, alignment: .topLeading)
        
        .background(.ultraThickMaterial)
        .clipped()
        
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
