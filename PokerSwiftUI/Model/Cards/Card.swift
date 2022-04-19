//
//  Card.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-14.
//

import Foundation

struct Card {
    
    var suit: Suit
    var rank: Rank
    
    func toString() -> String {
        return("\(rank) of \(suit.rawValue)")
    }
    
}


enum Suit: String, CaseIterable {
    case heart,
    diamond,
    club,
    spade
}

enum Rank: String, CaseIterable {
    case ace = "A",
         two = "2",
         three = "3",
         four = "4",
         five = "5",
         six = "6",
         seven = "7",
         eight = "8",
         nine = "9",
         ten = "10",
         jack = "J",
         queen = "Q",
         king = "K"
}

