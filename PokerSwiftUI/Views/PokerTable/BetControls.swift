//
//  BetControls.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct BetControls: View {
    var minBet: Float
    var maxBet: Float
    @State var curBet: Float
    @State var percentSelected: Percent = .free
    
    
    enum Percent: String, CaseIterable, Identifiable {
        case free = "Free", ten = "10%", twentyfive = "25%", fifty = "50%", allin = "all"
        var id: Self { self }
    }
    
    var body: some View {
        
        HStack {
        
            VStack{
                Slider(value: $curBet, in: minBet...maxBet, step: 1) {
                    Text("Bet Amount")
                } minimumValueLabel: {
                    Text("\(Int(minBet))")
                } maximumValueLabel: {
                    Text("\(Int(maxBet))")
                }
                .padding(.horizontal)
                Text("\(Int(curBet))")
                //Put a textfield here later
           
                Picker("Percent", selection: $percentSelected) {
                        ForEach(Percent.allCases) { percent in
                            Text(percent.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                
            }
        
        
            VStack{
                //if bet exists, change these to raise and fold respectively
                Button("Bet") {
                    
                }.padding()
                
                Button("Check") {
                    
                }.padding()
            }
        }.background(.ultraThickMaterial)
        
        
    }
}

struct BetControls_Previews: PreviewProvider {
    static var previews: some View {
        BetControls(minBet: 20, maxBet: 100, curBet: 20)
    }
}
