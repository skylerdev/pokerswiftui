//
//  Game.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import Foundation
import SwiftUI

struct Game: Codable {
    var started: Bool = false
    var players = [Player]()
}
