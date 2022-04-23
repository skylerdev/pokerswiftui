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

class TableModel: ObservableObject {
    
    //MARK: - INSTANCE VARIABLES
    
    var gameId: String = ""
    var myName: String = ""
    var myPlayerId: String = ""
    
    static let validChars = "qwertyuiopasdfghjklzxcvbnm"
    
    
    @Published var hosting: Bool = false
    @Published var joining: Bool = false
    
    @Published var exists: Bool = false
    
    @Published var game = Game()
    @Published var players = [Player]()
    
    //MARK: - COMPUTED PROPERTIES
    
    private let ref = Database.database().reference()
    private var rootPath: String {
        "tables/\(gameId)"
    }
    private var playerPath: String {
        "tables/\(gameId)/players"
    }
    private var gamePath: String {
        "tables/\(gameId)/game"
    }
    
    private var db: DatabaseReference {
        ref.child(rootPath)
    }
    var me: Player? {
        return players.first { p in
            p.id == myPlayerId
        }
    }

    //MARK: - INIT
    
    init(id: String){
        gameId = id
    }
    
    init(){
        //gameId = something random
    }
    
    
    func startListening() {
        print("Starting to listen for changes in the model")
        db.observe(.value) { snap in
            print(snap)
            let playerRef = snap.childSnapshot(forPath: "players")
            print(playerRef)
            guard let children = playerRef.children.allObjects as? [DataSnapshot] else {
                print("couldnt get all child objects")
                return
            }
            print(children)
            self.players = children.compactMap({ snap in
                return try! snap.data(as: Player.self)
            })
            print(self.players)
            
            self.game = try! snap.childSnapshot(forPath: "game").data(as: Game.self)
        }
    }

    //MARK: HOSTING AND JOINING
    
    func joinGame() {
        addPlayer()
        startListening()
    }
    
    func hostGame() {
        let autoId = TableModel.randomString(length: 4)
        print("generated \(autoId)")
        
        gameId = autoId
        ref.child("\(rootPath)/exists").setValue(true)
        
        do {
            try ref.child(gamePath).setValue(from: game)
        } catch let error {
            print("hostGame error")
            print(error.localizedDescription)
            return
        }
        addPlayer()
        startListening()
    
        
    }
    
    //MARK: - GAME FLOW
    
    func startGame() {
        ref.child("\(gamePath)/started").setValue(true)
        
        let p = getRandomPlayer()
        ref.child(pidToPath(id: p.id)).updateChildValues(["bigBlind" : true])
        
    }
    
    
    
    
    
    //MARK: - HELPERS
    
    func getRandomPlayer() -> Player {
        return players.randomElement()!
    }
    
    func pidToPath(id: String) -> String {
        return "\(playerPath)/\(id)"
    }
    
    func playerFromId(id: String) -> Player? {
        return players.first { p in
            p.id == id
        }
    }
    
    func addPlayer(){
        guard let autoId = ref.child(playerPath).childByAutoId().key else {
            print("joinGame autoId failure")
            return
        }
        myPlayerId = autoId
        let newPlayer = Player(id: myPlayerId, name: myName, chips: 1000)
        
        do {
            try ref.child(pidToPath(id: newPlayer.id)).setValue(from: newPlayer)
        } catch let error {
            print("joinGame setValue error")
            print(error.localizedDescription)
        }
    }
    
    
    static func randomString(length: Int) -> String {
          return String((0..<length).map{ _ in validChars.randomElement()! })
    }
    
    static func isOnlyLetters(input: String) -> Bool{
           let toValidate = input

           for c in toValidate {
               if(validChars.contains(c)){
                   continue
               }
               return false
           }
           return true
       }
    
    func gameExists() {
        print("GameExists called at \(rootPath)")
        ref.child("\(rootPath)/exists").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            print(snapshot)
            self.exists = snapshot.value as? Bool ?? false
        });
    }
    
   
    
}
