//
//  BetControls.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct BetControls: View {
    var minBet: Float = 20
    @State var curBet: Float
    @State var percentSelected: Percent = .ten
    var controlsEnabled: Bool
    @State var betText: String = "Bet"
    
    @EnvironmentObject var tableModel: TableModel
    
    var chips: Float {
        return Float(tableModel.me!.chips)
    }
    
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
                
                
                Text("\(Int(curBet))")
                //Put a textfield here later
                
           
                Picker("Percent", selection: $percentSelected) {
                        ForEach(Percent.allCases) { percent in
                            Text(percent.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
        
        
            VStack(){
                //if bet exists, change these to raise and fold respectively
                Button("Bet") {
                    print("Just hit the bet button")
                    tableModel.bet(amount: Int(curBet))
                }.padding()
        
                    
                   
                if(tableModel.game.betExists){
                    Button("Fold") {
                        print("just hit the fold button")
                        tableModel.fold()
                    }
                } else {
                    Button("Check") {
                        print("Just hit the check button")
                        tableModel.check()
                    }.padding()
                }
                
                
                
            }
        }.background(.ultraThickMaterial)
            .foregroundColor(controlsEnabled ? .accentColor : .gray)
            .disabled(!controlsEnabled)
            
    }
}

struct BetControls_Previews: PreviewProvider {
    static var previews: some View {
        BetControls(minBet: 20, curBet: 20, controlsEnabled: true)
            .environmentObject(TableModel(demoMode: true))
    }
}
