//
//  GameViewModel.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-17.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import Combine

class GameViewModel: ObservableObject {
    
    var gameId: String = ""
    var myName: String = ""
    
    @Published var hosting: Bool = false
    @Published var joining: Bool = false
    
    @Published var exists: Bool = false
    
    private let ref = Database.database().reference()
    private var dbPath: String {
        "tables/\(gameId)"
    }
    private var db: DatabaseReference {
        ref.child(dbPath)
    }
    
    @Published var game = Game(exists: false)
    @Published var players = [Player]()

    init(id: String){
        gameId = id
    }
    
    init(){
        //gameId = something random
    }
    
    func startListening() {
        print("Starting to listen for changes in the model")
        db.observe(.value) { snap in
            
            let playerRef = snap.childSnapshot(forPath: "players")
            guard let children = playerRef.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.players = children.compactMap({ snap in
                return try? snap.data(as: Player.self)
            })
            
            self.game = try! snap.data(as: Game.self)

        }
    }

    
    func gameExists() {
        print("GameExists called at \(dbPath)")
        ref.child("\(dbPath)/exists").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            print(snapshot)
            self.exists = snapshot.value as? Bool ?? false
        });
    }
    
   
    
}
