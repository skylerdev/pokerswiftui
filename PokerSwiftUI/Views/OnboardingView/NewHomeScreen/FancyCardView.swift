//
//  FancyCardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-10-21.
//

import SwiftUI

struct FancyCardView: View {
    let card: Card
    
    @State private var animationAmount: CGFloat = 90

    
    var body: some View {
        VStack {
            CardView(card: .init(suit: .club, rank: .ace))
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 3 , z: 0))
                
               
              
            CardView(card: .init(suit: .club, rank: .ace))
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 3, y: 1, z: 1))
            
           
                       
        }
        .animation(.easeIn(duration: 3)
            .delay(1)
            .repeatForever(autoreverses: true),
                   value: animationAmount)
        .onAppear {
            animationAmount = 1
        }
        
                
            
    }
}

struct FancyCardView_Previews: PreviewProvider {
    static var previews: some View {
        FancyCardView(card: Card.init(suit: .club, rank: .ace))
            .scaledToFit()
            .previewLayout(.sizeThatFits)
    }
}
