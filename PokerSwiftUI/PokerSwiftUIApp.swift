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
        Auth.auth().signInAnonymously { (authResult, error) in
            guard (authResult?.user) != nil else {
                print("DID NOT sign in we CANNOT use the app")
                return
            }
            print("we signed in :)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(TableModel())
        }
    }
}
