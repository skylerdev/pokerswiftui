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
        VStack(alignment: .leading, spacing: 3) {
            Text(player.name)
            if player.bet != 0 {
                Text("Bet: \(player.bet)")
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: Player(id: "jfjf", name: "bungler"))
    }
}
