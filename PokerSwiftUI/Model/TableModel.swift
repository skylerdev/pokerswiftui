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
import SwiftUI

class TableModel: ObservableObject {
    
    //MARK: - INSTANCE VARIABLES
    
    //These are modified using fields in home page
    var tableId: String = ""
    var myName: String = ""
    
    //This callback gets overwritten by home screen
    var dataInitCallback: () -> Void = {}
    
    static let validChars = "qwertyuiopasdfghjklzxcvbnm"
    
    
    //These variables actually control the transition between screens
    //Thats just how navigation views work!
    //For more info see HomeView.joinPressed()
    @Published var hosting: Bool = false
    @Published var joining: Bool = false
    
    
    @Published var exists: Bool = false
    
    //The game and its players
    @Published var game = Game()
    @Published var players = [Player]()
    
    //MARK: - COMPUTED PROPERTIES
    
    private let ref = Database.database().reference()
    
    //Just convenient firebase paths to common info
    private var rootPath: String {
        "tables/\(tableId)"
    }
    private var playerPath: String {
        "tables/\(tableId)/players"
    }
    private var gamePath: String {
        "tables/\(tableId)/game"
    }
    private var mePath: String {
        "tables/\(tableId)/players/\(myPlayerId)"
    }
    
    private var db: DatabaseReference {
        ref.child(rootPath)
    }
    
    //This is updated upon connecting to a game (autoid given by firebase)
    var myPlayerId: String = ""
    
    //lol best way to do this so far I guess
    var me: Player? {
        return players.first { p in
            p.id == myPlayerId
        }
    }
    var currentlyPlaying: Player? {
        return players.first { p in
            p.acting == true
        }
    }
    var currentlyPlayingIndex: Int {
        for i in 0..<players.count {
            if(players[i].acting){
                return i
            }
        }
        return -1
    }
    
    
    

    //MARK: - INIT
    
    init(id: String){
        tableId = id
    }
    
    init(demoMode: Bool){
        if(demoMode){
            players.append(Player(id: "DemoPlayer", name: "DemoPlayer", chips: 1000, totalRoundBet: 0, currentBet: 50, bigBlind: false, acting: false, hasActed: true, folded: false))
            players.append(Player(id: "meplayer", name: "Skyler", chips: 5000, totalRoundBet: 0, currentBet: 0, bigBlind: false, acting: true, hasActed: false, folded: false))
            players.append(Player(id: "andy", name: "Andy B", chips: 50, totalRoundBet: 0, currentBet: 0, bigBlind: false, acting: false, hasActed: false, folded: true))
            players.append(Player(id: "duncy", name: "Duncan", chips: 999999, totalRoundBet: 0, currentBet: 1000, bigBlind: true, acting: false, hasActed: true, folded: false))
            myPlayerId = "meplayer"
            
            game.beingPlayed = true
            game.pot = 1200
            game.betExists = true
            game.phase = .preflop
            self.tableId = "zzzz"

        }
    }
    
    init() {

    }
    
    //This method updates our game and players in real time when anyone makes changes to db
    //data(as:) converts db data into the object we tell it to (think casting)
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
            print("ENDCHANGE // \(TableModel.randomString(length: 9))")
            
            
            self.game = try! snap.childSnapshot(forPath: "game").data(as: Game.self)
            
            self.dataInitCallback()
        }
    }

    //MARK: HOSTING AND JOINING
    
    func joinGame() {
        addPlayer()
        startListening()
    }
    
    func hostGame() {
        
        let genID = TableModel.randomString(length: 4)
        self.tableId = genID

        
        ref.child("\(rootPath)/exists").setValue(true)
        print(rootPath)
        do {
            try ref.child(gamePath).setValue(from: game) { err in
                if let e = err {
                    print(e.localizedDescription)
                    return
                }else{
                    print("Added Game \(genID) Successfully, adding player + attaching listener...")
                    print("\(self.tableId)")
                    self.addPlayer()
                    self.startListening()
                }
                
            }
        } catch let error {
            print("hostGame error")
            print(error.localizedDescription)
            return
        }

        
    }
    
    //MARK: - GAME FLOW
    
    func startGame() {
        print("Starting game...")
        
        guard players.count > 1 else {
            print("started with less than 2 player somehow??")
            return
        }
        ref.child(gamePath).updateChildValues(["beingPlayed" : true]) { error, ref in
            if((error) != nil){
                print(error)
                return
            }
            print(ref)
        }
        
        
        
        let randomIndex = getRandomIndex()
        
        let p1 = players[randomIndex]
        //make one guy the big blind
        bigBlind(p: p1)
        
        let p2 = players[resolveIndex(index: randomIndex+1)]
        //make the guy after him the little blind
        littleBlind(p: p2)
        
        if(players.count == 2){
            ref.child(pidToPath(id: p2.id)).updateChildValues(["acting" : true])
        }else{
            let p3 = players[resolveIndex(index: randomIndex+2)].id
            ref.child(pidToPath(id: p3)).updateChildValues(["acting" : true])
        }
        ref.child(gamePath).updateChildValues(["betExists" : true])
      
    }
    
    //all of this is subject to change
    
    func bet(amount: Int) {
        let chipsAfterBet = me!.chips - amount
        
        ref.child(mePath).updateChildValues(["currentBet" : me!.currentBet + amount,
                                             "chips" : chipsAfterBet,
                                             "hasBet" : true ])
        ref.child(gamePath).updateChildValues(["betExists" : true])
        nextPlayer()
    }
    
    func check() {
        ref.child(mePath).updateChildValues(["hasBet" : true])
        nextPlayer()
    }
    
    func fold() {
        ref.child(mePath).updateChildValues(["folded" : true])
        nextPlayer()
    }
    
    func handIsComplete() -> Bool {
        var unfolded = 0
        var acted = 0
        for player in players {
            if(!player.folded){
                unfolded += 1
            }
            if(player.hasActed){
                acted += 1
            }
        }
        //case 1: everyone folded. last man standing wins
        if(unfolded == 1){
        //awardLastMan()
        }
        //case 2: everyone bet. move on dumbass
        if(acted == unfolded){
            return true
        }
        return true
    }
    
    func nextPlayer() {
        ref.child(mePath).updateChildValues(["acting" : false])
        
        
        //handComplete
        if(handIsComplete()){
            return
        }
        
        //are we done the current hand?
        let nextIndex = resolveIndex(index: currentlyPlayingIndex+1)
        let nPlayer = players[nextIndex]
        
        while(nPlayer.folded == true){
           // nPlayer = resolveIndex(index: <#T##Int#>)
        }
        
        let id = players[nextIndex].id
        print("\(id), \(players[nextIndex].name)")
        
        
        
       //get next player somehow
        
        print("\(currentlyPlayingIndex) next: \(nextIndex)")

        ref.child(pidToPath(id: id)).updateChildValues(["acting" : true])
        
    }
    
    func bigBlind(p: Player){
        let bbAmt = game.minBet * 2
        let chipsAfter = p.chips - bbAmt
        if(chipsAfter < 0){
            //TODO: All In Blind
            
        }else{
        ref.child(pidToPath(id: p.id)).updateChildValues(["bigBlind" : true,
                                                              "hasBet" : true,
                                                           "currentBet" : bbAmt,
                                                           "chips" : chipsAfter
                                                             ])
        }
    }
    
    func littleBlind(p: Player){
        let lbAmt = game.minBet
        let chipsAfter = p.chips - lbAmt
        if(chipsAfter < 0){
            //TODO: All in blind
        }else{
            ref.child(pidToPath(id: p.id)).updateChildValues(["littleBlind" : true,
                                                                  "hasBet" : true,
                                                               "currentBet" : lbAmt,
                                                               "chips" : chipsAfter
                                                                 ])
        }
    }
    
    
    //TODO: Unfinished
    func nextPhase(){
        for i in 0..<players.count {
            let id = players[i].id
            ref.child(pidToPath(id: id)).updateChildValues([
                "acting" : false,
                "hasBet" : false,
                "currentBet" : 0
            ])
        }
        //find blind, get next unfolded player
        let bIndex = players.firstIndex { p in
            p.bigBlind == true
        }
        guard let blindIndex = bIndex else {
            return
        }

        print("blind index = \(blindIndex)")
        var unfoldedIndex = blindIndex
        while(players[unfoldedIndex].folded == true){
            unfoldedIndex += 1
            if(unfoldedIndex == players.count) {
                
            }
            if(unfoldedIndex == blindIndex){
                
            }
        }
        
        //make them acting = true
        
    }
    
    
    
    //TODO: Unfinished
    func newRound(){
        for i in 0..<players.count {
            let id = players[i].id
            ref.child(pidToPath(id: id)).updateChildValues([
                "totalRoundBet" : 0,
                "currentBet" : 0,
                "acting" : false,
                "hasBet" : false,
                "folded" : false
            ])
        }
        
        //find blind, increment it
        
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
    
    func gameExists(gameID: String, callback: @escaping () -> Void = { }) {
        let rPath = "/tables/\(gameID)"
        print("GameExists called at \(rPath)")
        ref.child("\(rPath)/exists").observeSingleEvent(of: .value) { snap in
            print(snap)
            self.exists = snap.value as? Bool ?? false
            callback()
        }
    }
    
   
    
}
