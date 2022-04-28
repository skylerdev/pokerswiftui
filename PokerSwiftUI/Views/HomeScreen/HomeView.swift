//
//  HomeView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var gameViewModel: TableModel
    @State private var code: String = ""
    @State private var name: String = ""

    @State private var nameValid = false
    
    @State private var invalidFeedback: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                //The Title
                Text("PokerChips")
                    .bold()
                    .font(.largeTitle)
                
                //The Name Field
                TextField("Your Silly Little Name", text: $name, onEditingChanged: { isEditing in
                    if !isEditing {
                        nameValid = nameValidator()
                    }})
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                
                //The Room Code Field
                TextField("Room Code", text: $code, onEditingChanged: { isEditing in
                    if !isEditing {
                        codeValidator(input: code)
                    }})
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    
                NavigationLink(isActive: $gameViewModel.hosting) {
                    TableHost()
                } label: { EmptyView() }
                
                NavigationLink(isActive: $gameViewModel.joining) {
                    TableHost()
                } label: {
                    EmptyView()
                }
                
                HStack(alignment: .center, spacing: 10) {
                   
                    HostButton(pressed: hostPressed, valid: nameValid, text: "Host")
                    HostButton(pressed: joinPressed, valid: nameValid && gameViewModel.exists, text: "Join")
                }
                    
                    //TODO: Use an internal codeValid state in combination with .exists and nameValid?
                    //That way we can wait for .exists and even maybe add a loading indicator
                
                Text(gameViewModel.exists ? "" : invalidFeedback)
                    .foregroundColor(gameViewModel.exists ? .green : .red)
                    .animation(.spring().delay(0.2), value: gameViewModel.exists)
                    .frame(width: 200)
                    .animation(.spring().speed(10), value: invalidFeedback)
              
                
                
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
        gameViewModel.myName = name
        
        return true
    }
    
    func joinPressed() {
        print("tried to join")
        if(gameViewModel.exists){
            invalidFeedback = "Trying To Join..."
            gameViewModel.dataInitCallback = {
                gameViewModel.joining = true
            }
            gameViewModel.joinGame()
            
        }
    }
    
    func hostPressed() {
        print("tried to host")
        invalidFeedback = "Trying To Host..."
        gameViewModel.dataInitCallback = {
            gameViewModel.hosting = true
        }
        gameViewModel.hostGame()
       
    }
    
    func codeValidator(input: String) {
        gameViewModel.gameId = input.lowercased()
        gameViewModel.exists = false
        if(code.isEmpty){
            invalidFeedback = "Empty"
        }else if(code.count != 4){
            invalidFeedback = "Not 4 chars"
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
            .environmentObject(TableModel())
    }
}
