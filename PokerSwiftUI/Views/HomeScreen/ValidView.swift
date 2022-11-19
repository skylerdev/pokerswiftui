//
//  ValidView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-11-17.
//

import SwiftUI

struct ValidView: View {
    
    private var threeDimensional = false
    
    @State public var valid = false
    @State public var checking = false
    
    @State public var visible = true
    
    @State private var displaying = 0


    var body: some View {
        if(checking){
            if(threeDimensional){
                hyperCheckingText()
            }else{
                checkingText()
                    .opacity(visible ? 1 : 0)
            }
        }else{
            Text(valid ? "Valid" : "Invalid")
                .padding()
                .overlay(
                    Capsule()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 10]))
                    .onAppear {
                        withAnimation(.linear) {
                            displaying += 1
                        }
                    }
                    
                )
        }
       
    }
}

struct hyperCheckingText : View {
    
    @State private var degrees: CGFloat = 360
    
    var body: some View {
        
        Text("Checking...")
            .foregroundColor(.black)
            .padding()
            //First Circle
            .overlay(
                Circle()
                .scale(2)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 3, dash: [1]))
                .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 1, z: 0))
                .animation(.linear(duration: 3)
                    .repeatForever(autoreverses: false),
                           value: degrees)
                    .onAppear {
                        degrees = 1
                    }
            )
            //Second Circle
            .overlay( Circle()
                .scale(2)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 3, dash: [1]))
                .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: -1, z: 0))
                .animation(.linear(duration: 3)
                    .repeatForever(autoreverses: false),
                           value: degrees)
                    .onAppear {
                        degrees = 1
                    }
            )
    }
}


struct checkingText : View {
    
    @State private var phase = 0.0

    var body: some View {
        
        Text("Checking...")
            .padding()
            .overlay(
                Capsule()
                .scale(1)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [50, 5, 20, 5], dashPhase: phase))
                .onAppear {
                    withAnimation(.linear.repeatForever(autoreverses: false)) {
                        phase += 90
                    }
                }
                
            )
    }
}


struct ValidView_Previews: PreviewProvider {
    static var previews: some View {
        ValidView()
        checkingText()
    }
}
