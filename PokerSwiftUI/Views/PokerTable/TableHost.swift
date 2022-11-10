//
//  TableHost.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import SwiftUI

struct TableHost: View {
    
    @EnvironmentObject var tableModel: TableModel
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {       
            ZStack {
                //BACKGROUND CIRCLE
                Circle()
                    .scale(y: 3)
                    .offset(x: 180, y: 9)
                    .foregroundColor(.green)
                    .opacity(colorScheme == .dark ? 0.4 : 1)
                
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
                            
                            Text(tableModel.tableId)
                            
                            Text(tableModel.feedback)
                            Text("pot: \(tableModel.game.pot)")
                            
                            ForEach(tableModel.players) { p in
                                PlayerView(player: p)
                            }.padding()
                        }
                        switch tableModel.game.phase {
                        case .preflop:
                            TableCardsView(card1: Card(suit: .club, rank: .nine), card2: Card(suit: .spade, rank: .king)
                                           , card3: Card(suit: .heart, rank: .two), card4: Card(suit: .spade, rank: .queen), card5: Card(suit: .diamond, rank: .ten), stage: .flop)
                            .scaleEffect(x:0.8, y:0.8)
                            .padding(.bottom, -100)
                            .padding(.top, 20)
                        case .flop:
                            Text("Flop")
                        case .river:
                            Text("River")
                        case.turn:
                            Text("Turn")
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        YourCardsView(card1: Card(suit: .club, rank: .ace), card2: Card(suit: .diamond, rank: .ace))
                            .padding(.leading, 80)
                            .padding(.bottom, -40)


                        BetControls(controlsEnabled: tableModel.me!.acting)
                            .blur(radius: tableModel.me!.acting ? 0 : 4)
                            .animation(.easeInOut, value: tableModel.me!.acting)
                            
                    }
                    .padding(.top, -200)
                }
                .padding(.top, -100)
                
                
            } //ZSTACK: MAIN SCREEN
    }
}

struct TableHost_Previews: PreviewProvider {
    static var previews: some View {
        TableHost()
            .environmentObject(TableModel(demoMode: true))
            		
    }
}

