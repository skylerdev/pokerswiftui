//
//  Player.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import Foundation

struct Player: Codable, Identifiable {
    
    var id: String
    var name: String
    var chips: Int = 0
    var totalRoundBet: Int = 0
    var currentBet: Int = 0
    var bigBlind = false
    var isPlaying = false
    var hasBet = false
    var folded = false
    
    
}
