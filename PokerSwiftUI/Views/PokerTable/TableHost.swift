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
                    .offset(x: 180, y: -20)
                    .foregroundColor(.green)
                    .opacity(colorScheme == .dark ? 0.4 : 1)
                
                //EVERYTHING ELSE
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(tableModel.tableId)
                            
                            Text(tableModel.feedback)
                            HStack {
                                Text("pot: \(tableModel.game.pot)")
                                if(tableModel.hosting && !tableModel.game.beingPlayed && tableModel.players.count >= 2 ){
                                    StartButton {
                                        print("Pressed start")
                                        tableModel.startGame()
                                    }
                                }
                                
                            }
                            
                            ForEach(tableModel.players) { p in
                                PlayerView(player: p)
                            }.padding()
                        }

                        .offset(y: -75)
                        Spacer()
                        switch tableModel.game.phase {
                        case .preflop:
                            TableCardsView(cards: Array())                            .scaleEffect(x:0.8, y:0.8)
                            .padding(.vertical, 20)
                        case .flop:
                            TableCardsView(cards: Array(tableModel.game.cards[0...2]))
                            .scaleEffect(x:0.8, y:0.8)
                            .padding(.vertical, 20)
                        case .turn:
                            TableCardsView(cards: Array(tableModel.game.cards[0...3]))
                            .scaleEffect(x:0.8, y:0.8)
                            .padding(.vertical, 20)
                        case.river:
                            TableCardsView(cards: Array(tableModel.game.cards[0...4]))
                            .scaleEffect(x:0.8, y:0.8)
                            .padding(.vertical, 20)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                      
                            YourCardsView(card1: tableModel.me!.cards[0], card2:    tableModel.me!.cards[1])
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

