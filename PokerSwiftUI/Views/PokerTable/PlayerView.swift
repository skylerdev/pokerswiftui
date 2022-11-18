//
//  PlayerView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct PlayerView: View {
    var player: Player
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        HStack {
            MiniCardView(cards: player.cards)
                .padding(.leading, -60)
            ZStack {
                
                
                
                
                //MARK: - Current Bet for Player
                VStack {
                    HStack {
                        
                        Text("Bets:")
                            .foregroundColor(.primary)
                        
                        Text("\(player.currentBet)").bold()
                            .foregroundColor(.primary)
                        
                        
                        
                    }
                    .padding(.top, 10)
                    
                }
                
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .offset(y: player.currentBet != 0 ? 50 : 0)
                .animation(.spring(), value: player.currentBet)
                
                
                
                
                
                
                
                
                
                
                //MARK: Main Player View
                VStack {
                    VStack(alignment: .leading, spacing: 3) {
                        
                        Text(player.name)
                            .bold()
                            .foregroundColor(.primary)
                        
                        HStack(){
                            Image("PokerChip")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            //opacity workaround for folding
                                .overlay(content: {
                                    Circle().foregroundColor(.primary)
                                        .opacity(player.folded ? 0.60 : 0.00)
                                })
                            Text("\(player.chips)")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                    }
                    
                    .padding()
                    .frame(width: 151)
                    .background(.ultraThickMaterial)

                    
                    .background(player.hasActed ? .gray : .mint)
                    //coloring for has bet
                    .background(player.folded ? .gray : .clear)
                    .cornerRadius(10)
                }
                
                if(player.bigBlind){
                    Image(systemName: "b.circle.fill")
                        .offset(x:60, y:20)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                }else if(player.littleBlind){
                    Image(systemName: "b.circle")
                        .offset(x:60, y:20)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                }else{
                    Image(systemName: "b.circle")
                        .frame(width: 20, height: 20)
                        .hidden()
                        .foregroundColor(.primary)
                }
                
            }
            .foregroundColor(player.folded ? .gray : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(player.acting ? .green : .clear, lineWidth: 4)
                //            .animation(.easeInOut.repeatForever(), value: player.acting))
            )
            .padding(.trailing, -20)
            
            
        }
        
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        
        PlayerView(player:
                    Player(id: "huhahsdfj", name: "Dunco El Guapo", chips: 2849, totalRoundBet: 284, currentBet: 1236, bigBlind: true, acting: true, hasActed: false, folded: false)
        
        
            )
            .frame(width: 300, height: 300)
            .background(.cyan)
        
    }
}
