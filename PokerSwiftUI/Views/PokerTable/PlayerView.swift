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
                        Text("\(player.bet)").bold()
                    }
                    .padding(.top, 10)
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .offset(y: player.bet != 0 ? 50 : 0)
                .animation(.spring(), value: player.bet)
                
                
                
            
            
            VStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(player.name).bold()
                   
                        HStack(){
                        Image("PokerChip")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            Text("\(player.chips)")
                                                
                        }
                    
                }
                .padding()
                .background(.ultraThickMaterial)
            .cornerRadius(10)
                
              
                    
                
                
            }
        }
        
    
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        
        PlayerView(player: Player(id: "jfjf", name: "Dunco El Guapo", bet: 999999))
            .frame(width: 300, height: 300)
            .background(.cyan)
        
    }
}
