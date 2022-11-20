//
//  HomeView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var tableModel: TableModel
    @State private var code: String = ""
    @State private var name: String = ""
    
    @State private var nameValid = false
    @State var isAnimating = false // <1>
    
    @State private var nameInvalidFeeback: String = ""
    
    @State private var codeValidState: ValidState = .notRunning

    
    let minNameLen = 3
    let maxNameLen = 14
    
    var body: some View {
        NavigationView {
            ZStack {
            
                RotatingCardView(card: Card(suit: .heart, rank: .ace))
                    .offset(y: -200)
               
                
                
                VStack(alignment: .center) {
                    //The Title
                    Text("PokerChips")
                        .bold()
                        .font(.largeTitle)
                    
                    //The Name Field
                    TextField("Your Name", text: $name, onEditingChanged: { isEditing in
                        if !isEditing || isEditing {
                            nameValid = nameValidator()
                        }})
                    .offset(x:10)
                    .frame(height: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                

                    //The Room Code Field
                    TextField("Room Code", text: $code,onEditingChanged: { isEditing in
                        if !isEditing {
                            codeValidator()
                        }})
                    .offset(x:10)
                    .frame(height: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                    
                   
                    
                    HStack(alignment: .center) {
                        HostButton(pressed: hostPressed, valid: nameValid, text: "Host")
                            .padding(.horizontal)
                            .padding(.trailing, -10)
                        
                        HostButton(pressed: joinPressed, valid: nameValid && tableModel.exists, text: "Join")
                            .padding(.horizontal)
                            .padding(.leading, -10)
                        
                    }
                    
                    
                    //Buttons
                    
                    
                    //TODO: Use an internal codeValid state in combination with .exists and nameValid?
                    //That way we can wait for .exists and even maybe add a loading indicator
                    
                   
                    
                    Text(nameValid ? "" : nameInvalidFeeback)
                        .foregroundColor(nameValid ? .green : .red)
                        .animation(.spring().delay(0.2), value: nameValid)
                        .frame(width: 200)
                        .animation(.spring().speed(10), value: nameValid)
                    
                    //ValidView(state: self.codeValidState)
                    Text("\(codeValidState.rawValue)")
                    
                   
                    
                    
                    
                    //THESE ARE FOR NAV VIEW AND DO NOT FUNCTIONALLY EXIST
                    //Lets you join or host room
                    NavigationLink(isActive: $tableModel.hosting) {
                        TableHost()
                    } label: { EmptyView() }
                    
                    NavigationLink(isActive: $tableModel.joining) {
                        TableHost()
                    } label: { EmptyView() }
                  
                    ValidView(state: codeValidState)

                } // END VSTACK
            } // END ZSTACK
            
        } // END NAV VIEW
    }
    
    func nameValidator() -> Bool {
        if(name.isEmpty){
            return false
        }
        
        if(name == " " || name.isEmpty){
            nameInvalidFeeback = "Enter a name first"
            return false
        }
        if(!isOnlyLetters(input: name)){
            nameInvalidFeeback = "Your name can only be letters"
            return false
        }
        if(name.count < minNameLen){
            nameInvalidFeeback = "Min name length: \(minNameLen)"
            return false
        }
        if(name.count > maxNameLen ){
            nameInvalidFeeback = "Max name length: \(maxNameLen)"
            return false
        }
        nameInvalidFeeback = ""
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
        tableModel.myName = name
        
        return true
    }
    
    func isOnlyLetters(input: String) -> Bool{
        let toValidate = input
        for c in toValidate {
            if("abcdefghijklmnopqrstuvwxyz".contains(c)){
                continue
            }
            return false
        }
        return true
    }
    
    func joinPressed() {
        print("joinPressed: setting model to entered code \(code)")
        tableModel.tableId = code
        if(tableModel.exists){
            print("trying to join")
            print("joining game \(tableModel.tableId)")
            tableModel.dataInitCallback = {
                tableModel.joining = true
            }
            tableModel.joinGame()
            
        }
    }
    
    func hostPressed() {
        print("tried to host")
        tableModel.dataInitCallback = {
            tableModel.hosting = true
            
        }
        tableModel.hostGame()
       
    }
    
     func codeValidator() {
        tableModel.exists = false
         if(code.count != 4){
            print("Code not 4 letters")
            return
        }else{
            codeValidState = .running
            //code is valid, actually check db now
            tableModel.gameExists(gameID: code) {
                codeValidState = tableModel.exists ? .valid : .invalid
            }
            
        }
    }
    
}
     

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TableModel())
            .previewInterfaceOrientation(.portrait)
    }
}
