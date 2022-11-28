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
    var showing = false
    var won = false
    var hasBet: Bool {
        return currentBet != 0
    }
    var isAllIn: Bool {
        return chips == 0 && hasBet
    }
    var cards: [Card] = [Card(suit: .spade, rank: .ace), Card(suit: .heart, rank: .two)]
    
    mutating func reset() {
        totalRoundBet = 0
        currentBet = 0
        acting = false
        hasActed = false
        folded = false
        won = false
    }
    
    mutating func nextPhase() {
        currentBet = 0
        acting = false
        hasActed = false
    }
    
    mutating func addChips(chips: Int){
        self.chips += chips
    }
    
}
