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
import FirebaseFunctions

class TableModel: ObservableObject {
    
    lazy var functions = Functions.functions()

    //MARK: - INSTANCE VARIABLES
    let debugMode = false
    
    //These are modified using fields in home page
    var tableId: String = ""
    var myName: String = ""
    var feedback: String = ""
    
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
    private var playersPath: String {
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
    var currentlyPlayingIndex: Int? {
        for i in 0..<players.count {
            if(players[i].acting){
                return i
            }
        }
        return nil
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
            players.append(Player(id: "duncy", name: "Duncan", chips: 999999, totalRoundBet: 0, currentBet: 1000, bigBlind: true, acting: false, hasActed: true, folded: false, cards: [Card(suit: .spade, rank: .ten), Card(suit: .diamond, rank: .king)]))
            myPlayerId = "meplayer"
            
            game.beingPlayed = true
            game.pot = 1200
            game.phase = .river
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
            
            
            let playerRef = snap.childSnapshot(forPath: "players")
            guard let children = playerRef.children.allObjects as? [DataSnapshot] else {
                print("couldnt get all child objects")
                return
            }
            self.players = children.compactMap({ snap in
                return try! snap.data(as: Player.self)
            })
            
            if(self.debugMode){
                
                print("CHANGE IN MODEL //////////")
                print(snap)
                print(self.players)
                print("ENDCHANGE // \(TableModel.randomString(length: 9))")
            }
            
            
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
    
    //MARK: - GAME FLOW (POKER LOGIC)
    
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
        
        let i = getRandomIndex()
        setBlinds(bigBlindIndex: i)
        dealCards()
      
    }
    
    
    func setBlinds(bigBlindIndex: Int) {
        for p in players {
            ref.child(pidToPath(id: p.id)).updateChildValues(["bigBlind" : false, "littleBlind" : false])
        }
        
        let i = bigBlindIndex
        //make one guy the big blind
        let p1 = players[i]
        bigBlind(p: p1)
        
        //make the guy after him the little blind
        let p2 = players[resolveIndex(i+1)]
        littleBlind(p: p2)
        
        if(players.count == 2){
            ref.child(pidToPath(id: p2.id)).updateChildValues(["acting" : true])
        }else{
            let p3 = players[resolveIndex(i+2)].id
            ref.child(pidToPath(id: p3)).updateChildValues(["acting" : true])
        }
    }
    
    //MARK: BETCHECKFOLD
    
    //BET
    func bet(amount: Int) {
        //why is this a looooop
        for i in 0..<players.count {
            if(players[i].id == myPlayerId){
                players[i].currentBet += amount
                players[i].chips -= amount
                players[i].hasActed = true
            }
        }
        

        self.pushPlayers()
       
        self.goNext()
    }
    
    //CHECK
    func check() {
        for i in 0..<players.count {
            if(players[i].id == myPlayerId){
                players[i].hasActed = true
            }
        }
        self.pushPlayers()
        self.goNext()
    }
    
    //FOLD
    func fold() {
        for i in 0..<players.count {
            if(players[i].id == myPlayerId){
                players[i].folded = true
            }
        }
        self.pushPlayers()
        self.goNext()
    }
    
    func goNext() {
        print("gonext Called")
        ref.child(mePath).updateChildValues(["acting" : false])
        
        if(handIsOver()){
            endHand()
            return
        }
        
        if(phaseIsOver()){
            endPhase()
            return
        }
        
        guard let nextUnfoldedId = nextUnfoldedId() else {
            
            endHand()
            return
        }
        
        ref.child(pidToPath(id: nextUnfoldedId)).updateChildValues(["acting" : true])
        
    }
    
    func phaseIsOver() -> Bool {
        print("isPhaseOver")
        //does someone unfolded still have to play?
        //has everyone called the current biggest bet?
        
        let maxBet = curMaxBet()
        for player in players {
            print("\(player.name) folded? \(player.folded) bet? \(player.currentBet) max? \(maxBet)")
            if(!player.folded){
                if(!player.hasActed || player.currentBet != maxBet){
                    print("phase not over!")
                    return false
                }
            }
        }
        
        print("phase over!")
        //phase over
        return true
        
        
    }
    
    func endPhase() {
        print("ending the phase....")
        var roundPot = 0

        for i in 0..<players.count {
            let id = players[i].id
            
            //pot collects bets
            roundPot += players[i].currentBet
            players[i].currentBet = 0

    
            //everyone unfolded has not acted
            if(!players[i].folded){
                players[i].hasActed = false
                players[i].acting = false
            }
        }
        
        game.pot = game.pot + roundPot
    
        //give the next unfolded guy from bb actor
        
        guard let blindIndex = getBigBlindIndex() else {
            print("endPhase: couldnt find a big blind")
            return
        }
        var i = blindIndex
        for _ in players {
            if(!players[resolveIndex(i)].folded){
                players[resolveIndex(i)].acting = true
                break
            }
            i += 1
        }
        game.phase = GamePhase(rawValue: game.phase.rawValue + 1)!
        feedback = "entering phase \(game.phase.rawValue)"
        pushGame()
        pushPlayers()
        
    }
    
    func handIsOver() -> Bool {
        print("isHandOver? ")
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
            return true
        }
        //case 2: we are at the end.
        if(phaseIsOver() && game.phase == .river){
            return true
        }
        print(" unfolded: \(unfolded) acted: \(acted)")
        return false
    }
    
    
    func endHand() {

        
        //get the people whos hands we need to rank
        var unfolded = players.filter { p in
            p.folded == false
        }
        
        print(unfolded)
        
        if(unfolded.count == 1){
            //well. We have a winner
            newHand(winner: unfolded[0])
        }else{
            //get some hands going
            var hands: [String: [String]] = [:]
            for p in unfolded {
                hands[p.id] = p.cards.map({ c in
                    return c.toString()
                }) + game.cards.map({ c in
                    return c.toString()
                })
            }
            
            let dict : NSDictionary = hands as NSDictionary
            
            functions.httpsCallable("checkCards").call(["hands": dict]) { result, error in
              if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                  let code = FunctionsErrorCode(rawValue: error.code)
                  let message = error.localizedDescription
                  let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(code, message, details)
                }
                  //...
              }
              if let data = result?.data as? [String: Any], let id = data["id"] as? String {
                  print("Got a result from compareHands")
                  print(data)
                  guard let p = self.playerFromId(id: id) else {
                      print("couldnt get player from id comparehands gave us")
                      return
                  }
                  
                   
                self.newHand(winner: p)
              }
            }
        }
        
    }
    
    
    func newHand(winner: Player){
        print("calling new hand! winner was \(winner.name) with id of \(winner.id)")
        
        //collect the last chips
        var roundPot = 0

        for i in 0..<players.count {            
            //pot collects bets
            roundPot += players[i].currentBet
            players[i].currentBet = 0
        }
        
        game.pot = game.pot + roundPot
    
        
        //reset players
        for i in 0..<players.count {
            players[i].reset()
            if(players[i].id == winner.id){
                players[i].addChips(chips: game.pot)
            }
        }
        pushPlayers()
        
        
        //start a new hand
        let index = getBigBlindIndex()
        guard let bb = index else {
            print("newHand: couldnt find bigblind")
            return
        }
        
        //reset game
        game.handNumber += 1
        game.phase = .preflop
        game.pot = 0
        pushGame()
        
        setBlinds(bigBlindIndex: resolveIndex(bb+1))
        dealCards()
    }

    func getBigBlindIndex() -> Int? {
       return players.firstIndex { p in
            p.bigBlind == true
        }
    }

    func bigBlind(p: Player){
        let bbAmt = game.minBet * 2
        let chipsAfter = p.chips - bbAmt
        if(chipsAfter < 0){
            //TODO: All In Blind
            
        }else{
        ref.child(pidToPath(id: p.id)).updateChildValues(["bigBlind" : true,
                                                              "hasActed" : true,
                                                           "currentBet" : bbAmt,
                                                           "chips" : chipsAfter
                                                             ])
        }
    }
    
    
    
    
    func dealCards() {
        print("dealing cards")
     
        //Deck Generator
        let deck = CardDeck()
        
        
        //cards to players
        for p in players {
            let playerHand = [deck.popCard()!, deck.popCard()!]
            do {
                try ref.child("\(pidToPath(id: p.id))/cards").setValue(from: playerHand)
            } catch let error {
                print("dealCards setValuePlayer error: \(error.localizedDescription)")
            }
        }

        //cards to game
        var gameCards = [Card]()
        for i in 0...2 {
            //burn
            deck.popCard()
            //turn
            gameCards.append(deck.popCard()!)
            if(i == 2){
                gameCards.append(deck.popCard()!)
                gameCards.append(deck.popCard()!)
            }
        }
        do {
            try ref.child("\(gamePath)/cards").setValue(from: gameCards)
        } catch let error {
            print("dealCards setValueGame error: \(error.localizedDescription)")
        }

        
    }
    
    func littleBlind(p: Player){
        let lbAmt = game.minBet
        let chipsAfter = p.chips - lbAmt
        if(chipsAfter < 0){
            //TODO: All in blind
        }else{
            ref.child(pidToPath(id: p.id)).updateChildValues(["littleBlind" : true,
                                                                  "hasActed" : true,
                                                               "currentBet" : lbAmt,
                                                               "chips" : chipsAfter
                                                                 ])
        }
    }
    
    
    func curMaxBet() -> Int {
        var bets: [Int] = []
        for p in players {
            bets.append(p.currentBet)
        }
        return bets.max() ?? -99999
    }
    
    
    //MARK: - HELPERS
    
    func nextUnfoldedId() -> String? {
        //get current player
        guard let currentIndex = currentlyPlayingIndex else {
            print("nextUnfoldedId: no current player?")
            return nil
        }
        var i = currentIndex
        for _ in players {
            i += 1
            let j = resolveIndex(i)
            if(players[j].folded == false){
                return players[j].id
            }
        }
        print("nextUnfoldedId: no unfolded players??")
        return nil
    }
    
    func getRandomPlayer() -> Player {
        return players.randomElement()!
    }
    
    func getRandomIndex() -> Int {
        Int.random(in: 0..<players.count)
    }
    
    func resolveIndex(_ index: Int) -> Int {
        if(index < players.count){
            return index
        }
        
        return index - players.count
    }
    
    func pidToPath(id: String) -> String {
        return "\(playersPath)/\(id)"
    }
    
    func playerFromId(id: String) -> Player? {
        return players.first { p in
            p.id == id
        }
    }
    
    func addPlayer(){
        guard let autoId = ref.child(playersPath).childByAutoId().key else {
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
    
    func pushPlayers() {
        for p in players {
            do {
                try ref.child(pidToPath(id: p.id)).setValue(from: p)
            } catch let error {
                print("pushPlayers setValue error")
                print(error.localizedDescription)
            }
        }
      
    }
    
    func pushGame() {
        do {
            try ref.child(gamePath).setValue(from: game) { err in
                if let e = err {
                    print(e.localizedDescription)
                    return
                }else{
                    print("pushed game")
                }
                
            }
        } catch let error {
            print("pushgame error")
            print(error.localizedDescription)
            return
        }

    }
   
    
}
