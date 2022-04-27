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
    private var mePath: String {
        "tables/\(gameId)/players/\(myPlayerId)"
    }
    
    private var db: DatabaseReference {
        ref.child(rootPath)
    }
    var me: Player? {
        return players.first { p in
            p.id == myPlayerId
        }
    }
    var currentlyPlaying: Player? {
        return players.first { p in
            p.isPlaying == true
        }
    }
    var currentlyPlayingIndex: Int {
        for i in 0..<players.count {
            if(players[i].isPlaying){
                return i
            }
        }
        return -1
    }
    
    

    //MARK: - INIT
    
    init(id: String){
        gameId = id
    }
    
    init(demoMode: Bool){
        if(demoMode){
            players.append(Player(id: "DemoPlayer", name: "DemoPlayer", chips: 1000, totalRoundBet: 0, currentBet: 50, bigBlind: false, isPlaying: true, hasBet: true, folded: false))
            players.append(Player(id: "meplayer", name: "Skyler", chips: 1000, totalRoundBet: 0, currentBet: 0, bigBlind: false, isPlaying: false, hasBet: false, folded: false))
            players.append(Player(id: "andy", name: "Andy B", chips: 50, totalRoundBet: 0, currentBet: 0, bigBlind: false, isPlaying: false, hasBet: false, folded: true))
            players.append(Player(id: "duncy", name: "Duncan", chips: 999999, totalRoundBet: 0, currentBet: 1000, bigBlind: true, isPlaying: false, hasBet: true, folded: false))
            myPlayerId = "meplayer"
            
            game.beingPlayed = true
            game.pot = 1200
            game.betExists = true
            game.phase = .preflop
            
        }
    }
    
    init() {
        
    }
    
    
    func startListening() {
        print("Starting to listen for changes in the model")
        db.observe(.value) { snap in
            print("CHANGE IN MODEL //////////")
            print(snap)
            let playerRef = snap.childSnapshot(forPath: "players")
            guard let children = playerRef.children.allObjects as? [DataSnapshot] else {
                print("couldnt get all child objects")
                return
            }
            self.players = children.compactMap({ snap in
                return try! snap.data(as: Player.self)
            })
            print(self.players)
            print("ENDCHANGE ////////////")
            
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
        
        guard players.count > 1 else {
            print("started with less than 2 player somehow??")
            return
        }
        ref.child("\(gamePath)/started").setValue(true)
        
        let randomIndex = getRandomIndex()
        
        let firstId = players[randomIndex].id
        //make one guy the big blind
        ref.child(pidToPath(id: firstId)).updateChildValues(["bigBlind" : true,
                                                              "hasBet" : true,
                                                             //TODO: fix this
                                                             ])
        
        
        let secondId = players[resolveIndex(index: randomIndex+1)].id
        //make the guy after him the little blind
        ref.child(pidToPath(id: secondId)).updateChildValues(["littleBlind" : true])
        
        if(players.count == 2){
            ref.child(pidToPath(id: secondId)).updateChildValues(["isPlaying" : true])
        }else{
            let thirdId = players[resolveIndex(index: randomIndex+2)].id
            ref.child(pidToPath(id: thirdId)).updateChildValues(["isPlaying" : true])
        }
        
        
        
      
    }
    
    func bet(amount: Int) {
        ref.child(mePath).updateChildValues(["betting" : false, "currentBet" : amount])
    }
    
    
    
    
    //MARK: - HELPERS
    
    func getRandomPlayer() -> Player {
        return players.randomElement()!
    }
    
    func getRandomIndex() -> Int {
        Int.random(in: 0..<players.count)
    }
    
    func resolveIndex(index: Int) -> Int {
        if(index < players.count){
            return index
        }
        
        return index - players.count
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
