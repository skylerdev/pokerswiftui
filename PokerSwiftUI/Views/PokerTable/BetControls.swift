//
//  BetControls.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct BetControls: View {
    
    @State var percentSelected: Percent = .ten
    var controlsEnabled: Bool
  //@State var betText: String = "Bet"
    
    @EnvironmentObject var tableModel: TableModel
    
    var chips: Float {
        return Float(tableModel.me!.chips)
    }
    
    var minBet: Float {
        if(tableModel.curMaxBet() != 0){
            var bets: [Int] = []
            for p in tableModel.players {
                bets.append(p.currentBet)
            }
            let call = bets.max() ?? -99999
            let callDiff = call - tableModel.me!.currentBet
            return Float(callDiff)
        }else{
            return 20
        }
    }
    
    @State var curBet: Float = 20
    
    enum Percent: String, CaseIterable, Identifiable {
        case ten = "10%", twentyfive = "25%", fifty = "50%", allin = "all"
        var id: Self { self }
    }
    
    var body: some View {
        
        HStack {
            VStack{
                if(chips <= minBet){
                    Text("Bet or dont bro")
                }else{
                    Slider(value: $curBet, in: minBet...chips, step: 1) {
                        Text("Bet Amount")
                    } minimumValueLabel: {
                        Text("\(Int(minBet))")
                    } maximumValueLabel: {
                        Text("\(Int(chips))")
                    }
                    .padding(.horizontal)
                    .onChange(of: percentSelected) { newValue in
                        switch newValue {
                        case .ten:
                            curBet = chips * 0.10
                        case .twentyfive:
                            curBet = chips * 0.25
                        case .fifty:
                            curBet = chips * 0.50
                        case .allin:
                            curBet = chips
                        }
                        
                        if(curBet < minBet){
                            curBet = minBet
                        }
                        
                    }
                   
                    
                
                if(curBet <= minBet){
                    Text("\(Int(minBet))")
                }else{
                    Text("\(Int(curBet))")
                }
                //Put a textfield here later
                
           
                Picker("Percent", selection: $percentSelected) {
                        ForEach(Percent.allCases) { percent in
                            Text(percent.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading, 30)
                }
                
            }
        
        
            VStack(){
                //if bet exists, change these to raise and fold respectively
            
                    
                //CALL / RAISE TEXT
                if(tableModel.curMaxBet() != 0){
                    Button(curBet <= minBet ? "Call" : "Raise") {
                        print("Call / Raise Pressed")
                        //get biggest amt currently bet in the table. use it
                        curBet = curBet <= minBet ? minBet : curBet
                        tableModel.bet(amount: Int(curBet))
                    }.padding()
                        .buttonStyle(.bordered)
                        .padding(.trailing, 10)
                    Button("Fold") {
                        print("Fold Pressed")
                        tableModel.fold()
                    }
                    .buttonStyle(.bordered)
                    .padding(.trailing, 10)
                } else {
                    Button("Bet") {
                        print("Bet Pressed")
                        curBet = curBet <= minBet ? minBet : curBet
                        tableModel.bet(amount: Int(curBet))
                    }.padding()
                    Button("Check") {
                        print("Check Pressed")
                        tableModel.check()
                    }.padding()
                }
                
                
                
            }
        }.background(.regularMaterial)
            .foregroundColor(controlsEnabled ? .accentColor : .gray)
            .disabled(!controlsEnabled)
            
    }
}

struct BetControls_Previews: PreviewProvider {
    static var previews: some View {
        BetControls(controlsEnabled: true)
            .environmentObject(TableModel(demoMode: true))
    }
}
