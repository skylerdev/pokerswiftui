//
//  PlayerView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct PlayerView: View {
    var player: Player
    
    
    var body: some View {
        
        ZStack {
            
                //MARK: - Betting
                VStack {
                    HStack {
                       
                            Text("Bets:")
                            Text("\(player.currentBet)").bold()
                            
                    }
                    .padding(.top, 10)
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .offset(y: player.currentBet != 0 ? 50 : 0)
                .animation(.spring(), value: player.currentBet)
                
                
                
            
            
            VStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(player.name)
                        .bold()
                  
                        HStack(){
                        Image("PokerChip")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            //opacity workaround for folding
                            .overlay(content: {
                                Circle().foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: player.folded ? 0.60 : 0.00))
                            })
                            Text("\(player.chips)")
                                                
                        }
                    
                }
                
                .padding()
                .background(.ultraThickMaterial)
                .background(player.hasBet ? .gray : .mint)
                //coloring for has bet
                .background(player.folded ? .gray : .clear)
                .cornerRadius(10)
                
                
            }
        }
        .foregroundColor(player.folded ? .gray : .black)
        .shadow(color: player.isPlaying ? .red : .clear, radius: 5, x: 0, y: 0)
        .animation(.easeOut, value: player.isPlaying)
    
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        
        PlayerView(player:
                    Player(id: "huhahsdfj", name: "Dunco El Guapo", chips: 2849, totalRoundBet: 284, currentBet: 999999, bigBlind: false, isPlaying: true, hasBet: false, folded: false)
        
        
            )
            .frame(width: 300, height: 300)
            .background(.cyan)
        
    }
}
