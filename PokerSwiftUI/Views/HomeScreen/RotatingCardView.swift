//
//  FancyCardView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-10-21.
//

import SwiftUI

struct RotatingCardView: View {
    let card: Card
    
    @State private var animationAmount: CGFloat = 360
    
    var body: some View {
            CardView(card: card)
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1 , z: 0), anchor: .center)
                .onAppear {
                    //-1 hour lmao
                    DispatchQueue.main.async {
                        withAnimation(.linear(duration: 3)
                                      
                            .repeatForever(autoreverses: false)){
                                animationAmount = 0
                            }
                    }
                }
    }
}

struct FancyCardView_Previews: PreviewProvider {
    static var previews: some View {
        RotatingCardView(card: Card.init(suit: .club, rank: .ace))
            .scaledToFit()
            .previewLayout(.sizeThatFits)
    }
}
