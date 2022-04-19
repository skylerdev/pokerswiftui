//
//  PokerSwiftUIApp.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-10.
//

import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct PokerSwiftUIApp: App {
    init() {
        FirebaseApp.configure()
        var players = [Player]()
        
        
        Database.database().reference().child("tables/ageb/players").observe(.value) { snap in
            guard let children = snap.children.allObjects as? [DataSnapshot] else {
                return
            }
            //this is where the codable magic happens
            players = children.compactMap({ snapshot in
                return try? snapshot.data(as: Player.self)
            })
            print(players)
            
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GameViewModel())
        }
    }
}
