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
                    .limitInputLength(value: $name, length: 16)
                
                //The Room Code Field
                TextField("Room Code", text: $code, onEditingChanged: { isEditing in
                    if !isEditing {
                        codeValidator()
                    }})
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .limitInputLength(value: $code, length: 4)
                    
                
                //Lets you join or host room
                NavigationLink(isActive: $tableModel.hosting) {
                    TableHost()
                } label: { EmptyView() }
                
                NavigationLink(isActive: $tableModel.joining) {
                    TableHost()
                } label: { EmptyView() }
                
                
                //Buttons
                HStack(alignment: .center, spacing: 10) {
                    HostButton(pressed: hostPressed, valid: nameValid, text: "Host")
                    HostButton(pressed: joinPressed, valid: nameValid && tableModel.exists, text: "Join")
                }
                    
                    //TODO: Use an internal codeValid state in combination with .exists and nameValid?
                    //That way we can wait for .exists and even maybe add a loading indicator
                
                //Invalid feedback
                Text(tableModel.exists ? "" : invalidFeedback)
                    .foregroundColor(tableModel.exists ? .green : .red)
                    .animation(.spring().delay(0.2), value: tableModel.exists)
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
        //TODO: alphanumeric check here please
        tableModel.myName = name
        
        return true
    }
    
    func joinPressed() {
        print("joinPressed: setting model to entered code \(code)")
        tableModel.tableId = code
        if(tableModel.exists){
            invalidFeedback = "Trying To Join..."
            print("joining game \(tableModel.tableId)")
            tableModel.dataInitCallback = {
                tableModel.joining = true
            }
            tableModel.joinGame()
            
        }
    }
    
    func hostPressed() {
        print("tried to host")
        invalidFeedback = "Trying To Host..."
        tableModel.dataInitCallback = {
            tableModel.hosting = true
            
        }
        tableModel.hostGame()
       
    }
    
    func codeValidator() {
        tableModel.exists = false
        if(code.isEmpty){
            invalidFeedback = "Invalid"
        }else if(code.count != 4){
            invalidFeedback = "Invalid"
        }else{
            invalidFeedback = "Checking..."
            //code is valid, actually check db now
            tableModel.gameExists(gameID: code) {
                invalidFeedback = tableModel.exists ? "Exists" : "Game does not exist"
            }
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TableModel())
    }
}


struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}
