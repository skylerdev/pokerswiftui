//
//  FoldButton.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct FoldButton: View {
       @GestureState var isDetectingLongPress = false
       @State var completedLongPress = false

       var longPress: some Gesture {
           LongPressGesture(minimumDuration: 1)
               .updating($isDetectingLongPress) { currentState, gestureState,
                       transaction in
                   gestureState = currentState
                   transaction.animation = Animation.easeInOut(duration: 0.4)
               }
               .onEnded { finished in
                   self.completedLongPress = finished
               }
       }

       var body: some View {
           ZStack {
               Capsule()
               .frame(width: 100, height: 30)
               .foregroundColor(.green)
               Capsule()
             
               .foregroundColor(.red)
               Text("Fold")
               Capsule()
               .frame(width: 100, height: 30)
               .foregroundColor(.clear)
               .gesture(longPress)
           }
       }
}

struct FoldButton_Previews: PreviewProvider {
    static var previews: some View {
        FoldButton()
    }
}
