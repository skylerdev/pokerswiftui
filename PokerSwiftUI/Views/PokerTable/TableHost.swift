//
//  TableHost.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableHost: View {
    
    @EnvironmentObject var gameViewModel: TableModel
    @State var curBet = true
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("hello there, \(gameViewModel.myName)")
                
            }
            ZStack {
                Circle()
                    .scale(y: 3)
                    .offset(x: 180, y: 9)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    ForEach(gameViewModel.players) { p in
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
            .environmentObject(TableModel(id: "ageb"))
            
    }
}
