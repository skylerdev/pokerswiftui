//
//  HyperValidView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-11-19.
//

import SwiftUI

struct HyperValidView : View {
    
    @State private var degrees: CGFloat = 360
    @State private var shouldDisplay: Bool = true
    
    var body: some View {
        
        Text("Checking...")
            .foregroundColor(.black)
            .padding()
            .opacity(shouldDisplay ? 1 : 0.5)
            .animation(.easeInOut(duration: 1)
                .repeatForever(), value: shouldDisplay
            )
            .onAppear() {
                shouldDisplay = false
            }
            //First Circle
            .overlay(
                Circle()
                .scale(2)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 3, dash: [1]))
                .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 1, z: 1))
                .animation(.linear(duration: 3)
                    .repeatForever(autoreverses: false),
                           value: degrees)
                    .onAppear {
                        degrees = 0
                    }
            )
            //Second Circle
            .overlay(Circle()
                .scale(2)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 3, dash: [1]))
                .rotation3DEffect(.degrees(degrees), axis: (x: -1, y: 1, z: 1))
                .animation(.linear(duration: 3)
                    .repeatForever(autoreverses: true),
                           value: degrees)
                    .onAppear {
                        degrees = 1
                    }
            )
    }
}

struct HyperValidView_Previews: PreviewProvider {
    static var previews: some View {
        HyperValidView()
    }
}
