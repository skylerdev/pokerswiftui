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
    var acting = false
    var hasActed = false
    var folded = false
    var littleBlind = false
    
 
    
    mutating func reset() {
        totalRoundBet = 0
        currentBet = 0
        acting = false
        hasActed = false
        folded = false
        bigBlind = false
    }
    
    mutating func nextPhase() {
        currentBet = 0
        acting = false
        hasActed = false
    }
    
    
}
