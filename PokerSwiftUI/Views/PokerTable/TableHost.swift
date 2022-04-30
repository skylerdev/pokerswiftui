//
//  TableHost.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableHost: View {
    
    @EnvironmentObject var tableModel: TableModel
    @State var curBet = true
    
    
    var body: some View {       
            ZStack {
                //BACKGROUND CIRCLE
                Circle()
                    .scale(y: 3)
                    .offset(x: 180, y: 9)
                    .foregroundColor(.green)
                
                //EVERYTHING ELSE
                VStack {
                    if(tableModel.hosting && !tableModel.game.beingPlayed && tableModel.players.count >= 2 ){
                        StartButton {
                            print("Pressed start")
                            tableModel.startGame()
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(tableModel.gameId)
                            
                            ForEach(tableModel.players) { p in
                                PlayerView(player: p)
                            }.padding()
                        }
                        switch tableModel.game.phase {
                        case .preflop:
                            Text("Preflop")
                        case .flop:
                            Text("Flop")
                        case .river:
                            Text("River")
                        case.turn:
                            Text("Turn")
                        }
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        //YourCardsView(card1: card1, card2: card2)
                        BetControls(minBet: 20, curBet: 20, controlsEnabled: tableModel.me!.acting)
                            
                    }
                }
                
                
            } //ZSTACK: MAIN SCREEN
    }
}

struct TableHost_Previews: PreviewProvider {
    static var previews: some View {
        TableHost()
            .environmentObject(TableModel(demoMode: true))
            
    }
}

