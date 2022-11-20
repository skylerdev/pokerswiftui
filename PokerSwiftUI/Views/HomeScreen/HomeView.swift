//
//  HomeView.swift
//  PokerSwiftUI
//
//  Created by Skyler Devlaming on 2022-04-15.
//

import SwiftUI

struct HomeView: View {
    
    let minNameLen = 1
    
    @EnvironmentObject var tableModel: TableModel
    @ObservedObject var name = AlphanumericInput(limit: 18, nums: true)
    @ObservedObject var code = AlphanumericInput(limit: 4, nums: false)
        
    @State private var codeValidState: ValidState = .notRunning

    
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
                    TextField("Your Name", text: $name.value)
                    .offset(x:10)
                    .frame(height: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    
                
                    //The Room Code Field
                        TextField("Room Code", text: $code.value, onEditingChanged: { isEditing in
                            if !isEditing {
                                codeValidator()
                            }})
                    .offset(x: 10)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height: 50)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    HStack(alignment: .center) {
                        HostButton(pressed: hostPressed, valid: ( minNameLen < name.value.count), text: "Host")
                            .padding(.horizontal)
                            .padding(.trailing, -10)
                        
                        HostButton(pressed: joinPressed, valid: minNameLen < name.value.count && tableModel.exists, text: "Join")
                            .padding(.horizontal)
                            .padding(.leading, -10)
                        
                    }
                    
   
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
    
    
    func joinPressed() {
        print("joinPressed: setting model to entered code \(code)")
        tableModel.tableId = code.value
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
        let defaults = UserDefaults.standard
        defaults.set(name.value, forKey: "name")
        tableModel.myName = name.value
        print("tried to host")
        tableModel.dataInitCallback = {
            tableModel.hosting = true
            
        }
        tableModel.hostGame()
    }
    
     func codeValidator() {
        tableModel.exists = false
         if(code.value.count != 4){
            print("Code not 4 letters")
            return
        }else{
            codeValidState = .running
            //code is valid, actually check db now
            tableModel.gameExists(gameID: code.value) {
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
