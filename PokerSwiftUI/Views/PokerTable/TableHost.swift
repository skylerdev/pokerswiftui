//
//  TableHost.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableHost: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @State var curBet = true
    
    init(){
        print("tablehost init")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("hello there, \(gameViewModel.myName)")
            ZStack {
                Circle()
                    .scale(y: 3)
                    .offset(x: 180, y: 9)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    ForEach(gameViewModel.game.players) { p in
                        PlayerView(player: p)
                    }.padding()
                }
            }
            HStack {
                //YourCardsView(card1: card1, card2: card2)
                BetControls(minBet: 0, maxBet: 100, curBet: 3)
            }
        } //VSTACK
        
    }
}

struct TableHost_Previews: PreviewProvider {
    static var previews: some View {
        TableHost()
            .environmentObject(GameViewModel(id: "ageb"))
            
    }
}
