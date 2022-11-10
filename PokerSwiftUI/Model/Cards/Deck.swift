//
//  Deck.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import Foundation

class CardDeck {
    
    private var deck: [Card]
    
    init(){
        deck = [Card]()
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deck.append(Card(suit: suit, rank: rank))
            }
        }
        
        deck.shuffle()
    }
    
    
    func popCard() -> Card? {
        return deck.popLast()
    }
    
    
    
}
