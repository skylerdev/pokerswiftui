//
//  ExampleGame.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import Foundation

func ExampleGame() -> Game {
    let playerOne = Player(id: "woifehn", name: "John", chips: 500)
    let playerTwo = Player(id: "wobsnsn", name: "Randy", chips: 900)
    let playerThree = Player(id: "woiehn", name: "Dinglebat Man", chips: 100)
    let playerFour = Player(id: "woianb", name: "Andy", chips: 0)
    
    let game = Game(started: false, players: [playerOne, playerTwo,playerThree, playerFour])
    
    return game
    
}
