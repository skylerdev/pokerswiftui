//
//  Game.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import Foundation

//Hand = deal of the cards
//Phase = Round = betting round = always 4 of these

struct Game: Codable {
    //There are 4 betting phases each hand
    var phase: GamePhase = .preflop
    
    //How many hands have taken place
    var handNumber: Int = 0
    
    //Whether the game has started or is on pause
    var beingPlayed: Bool = false
    
    //MARK: - Game Logic
    
    //The current pot to win the game
    //Each player should have their own pot var
    var pot: Int = 0
    
    //what the min bet is
    var minBet: Int = 20
    
    var cards: [Card] = [Card(suit: .heart, rank: .two), Card(suit: .heart, rank: .two), Card(suit: .heart, rank: .two), Card(suit: .heart, rank: .two), Card(suit: .heart, rank: .two)]
    
}




enum GamePhase: Int, Codable, CaseIterable {
    case preflop, flop, turn, river
}
