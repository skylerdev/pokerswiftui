//
//  PokerSwiftUIApp.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-10.
//

import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct PokerSwiftUIApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GameViewModel())
        }
    }
}
