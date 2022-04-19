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
    
    @Published var game = Game()

    init(id: String){
        gameId = id
    }
    
    init(){
        //gameId = something random
    }
    
    func startListening() {
        db.observe(.value) { snap in
            print(snap)
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
