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
            CardView(card: card2)
//                    .shadow(radius: 2, x:2)
                    .rotationEffect(Angle(degrees: 10))
                    .offset(x:50)
            
            CardView(card: card1)
                 .rotationEffect(Angle(degrees: -10))
//                 .shadow(radius: 2, x:2)
                 .offset(x:-50)

        }
        .scaleEffect(x:0.8, y:0.8)
       // .padding(.all, 6.0)
        
    }
}

struct YourCardsView_Previews: PreviewProvider {
    static var previews: some View {
        YourCardsView(card1: Card(suit: .heart, rank: .nine), card2: Card(suit: .spade, rank: .king))
            .previewLayout(.sizeThatFits)
    }
}
