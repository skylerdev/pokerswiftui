//
//  HomeView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var code: String = ""
    @State private var name: String = ""

    @State private var nameValid = false
    
    @State private var invalidFeedback: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                //The Title
                Text("PokerChips")
                    .bold()
                    .font(.largeTitle)
                
                //The Name Field
                TextField("Your Silly Little Name", text: $name)
                    .onSubmit {
                        nameValid = nameValidator()
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                
                //The Room Code Field
                TextField("Room Code", text: $code)
                    .onSubmit {
                        codeValidator()
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    
                
                HStack {
                    NavigationLink(isActive: $gameViewModel.hosting) {
                        TableHost()
                    } label: {
                        Button {
                            hostPressed()
                        } label: {
                            Text("Host")
                                .foregroundColor(.accentColor)
                        }
                        .padding(nameValid ? 30 : 10)
                        .background(nameValid ? .green : .red )
                        .opacity(nameValid ? 1 : 0.15)
                        .cornerRadius(10)
                        .animation(.spring(), value: nameValid)
                        .disabled(!nameValid)
                    }
                    
                    
                    NavigationLink(isActive: $gameViewModel.joining) {
                        TableHost()
                    } label: {
                        Button {
                            joinPressed()
                        } label: {
                            Text("Join")
                                .foregroundColor(.accentColor)
                        }
                        .padding(nameValid && gameViewModel.exists ? 30 : 10)
                        .background(nameValid && gameViewModel.exists ? .green : .red )
                        .opacity(nameValid && gameViewModel.exists ? 1 : 0.15)
                        .cornerRadius(10)
                        .animation(.spring(), value: nameValid && gameViewModel.exists)
                        .disabled(!(nameValid && gameViewModel.exists))
                    }
                    //TODO: Use an internal codeValid state in combination with .exists and nameValid?
                    //That way we can wait for .exists and even maybe add a loading indicator
                    
                }.padding()
                
                
                Text(gameViewModel.exists ? "" : invalidFeedback)
                    .foregroundColor(gameViewModel.exists ? .green : .red)
                    .animation(.spring().delay(1), value: gameViewModel.exists)
                    .frame(width: 200)
                    
                Spacer()
                
            }.padding()
        }
    }
    
    func nameValidator() -> Bool {
        if(name.isEmpty){
            return false
        }
        if(name.count > 15){
            return false
        }
        //alphanumeric check here please
        
        
        return true
    }
    
    func joinPressed() {
        print("fuck")
        if(gameViewModel.exists){
            gameViewModel.joining = true
            print("tried to join")
        }
    }
    
    func hostPressed() {
        print("shit")
        print("tried to host")
        //create game from scratch
        
        gameViewModel.hosting = true
    }
    
    func codeValidator() {
        gameViewModel.gameId = code.lowercased()
        if(code.isEmpty){
            invalidFeedback = "Empty"
            gameViewModel.exists = false
        }else if(code.count != 4){
            invalidFeedback = "Not 4 chars"
            gameViewModel.exists = false
        }else{
            
            //code is valid, actually check db now
            gameViewModel.gameExists()
            invalidFeedback = "Game Does Not Exist"
        }
    }
    
    
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GameViewModel())
    }
}
