//
//  YourCardsView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct YourCardsView: View {
    var card1: Card
    var card2: Card
    
    var body: some View {
        ZStack {
           CardView(card: card1)
              
            CardView(card: card2)
                .offset(x: 10, y: 10)
        }
       // .padding(.all, 6.0)
        .padding()
            
            .background(.ultraThinMaterial)
            .cornerRadius(2)
        
    }
}

struct YourCardsView_Previews: PreviewProvider {
    static var previews: some View {
        YourCardsView(card1: Card(suit: .heart, rank: .nine), card2: Card(suit: .spade, rank: .king))
            .previewLayout(.sizeThatFits)
    }
}
