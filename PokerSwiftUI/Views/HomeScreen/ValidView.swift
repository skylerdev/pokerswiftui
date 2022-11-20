//
//  ValidView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-11-17.
//

import SwiftUI

struct ValidView: View {
        
    var state: ValidState
    
    private var color: Color {
        switch state {
        case ValidState.valid:
            return .green
        case ValidState.invalid:
            return .red
        default:
            return .black
        }
    }
    private var text: String {
        switch state {
        case ValidState.valid:
            return "Valid"
        case ValidState.invalid:
            return "Invalid"
        default:
            return "Checking..."
        }
    }
    @State private var shouldDisplay: Bool = false
    
    @State private var phase: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(color, style: StrokeStyle(lineWidth: 4, dash: [50, 5, 20, 5], dashPhase: phase))
           
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.linear.repeatForever(autoreverses: false)) {
                        if(state == .running) {
                            phase += 100
                        }
            }}}
            

            Text(text)
        
           
            
        }//END ZSTACK
        .frame(width: 100, height: 30)
        .opacity(shouldDisplay ? 1 : 0)
        .onChange(of: state, perform: { newValue in
            shouldDisplay = true
            
            if(newValue == .valid || newValue == .invalid){
                withAnimation(.easeOut(duration: 1)) {
                        shouldDisplay = false
                }
            }
        })

        
       
    }
}

enum ValidState: Int {
    case notRunning = 0, running = 1, valid = 2, invalid = 3
    
}



struct ValidView_Previews: PreviewProvider {
    static var previews: some View {
        ValidView(state: .valid
                  
        )
            .previewLayout(.sizeThatFits)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
