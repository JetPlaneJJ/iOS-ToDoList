//
//  ContentView.swift
//  TestApplication
//
//  Created by Jay Lin on 6/15/20.
//  Copyright © 2020 Jay Lin. All rights reserved.
//
// This is the main page that appears after storyboard.


import SwiftUI

struct ContentView: View {
    @State var input: String = "" // represents user input in "New Item" text field
    @State var titleInput: String = ""
    @State private var title: String = UserDefaults.standard.string(forKey: "title") ?? "Enter List Name" // represents list title to be saved
    @State private var items = UserDefaults.standard.stringArray(forKey: "todoList") ?? [String]() // represents things in todo list
    
    // Adds todo items into list and saves to bundle
    func addToList() {
        if (self.input != "") {
            self.items.append(self.input)
            self.input = ""
            UserDefaults.standard.set(self.items, forKey: "todoList")
        }
    }
    
    // Removes todo items from list and updates bundle
    func removeFromList(name: String) {
        self.items = self.items.filter(){$0 != name}
        UserDefaults.standard.set(self.items, forKey: "todoList")
    }
    
    // Sets the Title of the ToDo List and saves to bundle
    func setTitle() {
        self.title = self.titleInput
        UserDefaults.standard.set(self.titleInput, forKey: "title")
    }
    
    // Main Body
    var body: some View {
        // Upper quarter of screen
        VStack(alignment: .center) {
            TextField(title, text: $titleInput,
                onCommit: {
                    self.setTitle()
            })
                .padding()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                TextField("New Item", text: $input,
                    onCommit: {
                        self.addToList()
                    })
                    .padding(.horizontal).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.addToList()
                }) {
                    Text("Add Item")
                        .padding(5)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                .padding(.trailing)
            }
            // ToDo List
            List {
                if self.items.count != 0 {
                    ForEach(items, id: \.self) { item in
                        // ToDo List Row contents
                        HStack {
                            Text(item)
                                .onTapGesture {
                                    self.removeFromList(name: item)
                            }
                            Spacer()
                            Button(action: {
                                self.removeFromList(name: item)
                            }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding(.trailing)
        }
        .padding(.top)
    }   
}

struct TestUsername : View {
    @ObservedObject var textBindingManager = TextBindingManager(limit: 15)
    
    // prevent users from signing up with same username
       @State private var isAvailable = 2
       @State private var moveForward = false
       
       @State private var loading = false // loading wheel
       
       // auto focus
       @State private var isUsernameFirstResponder: Bool? = true
       @State private var usernamePlaceHolder = "hello.hi"
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("@")

                    AutoFocusTextField(text: self.$textBindingManager.text, nextResponder: .constant(nil), isResponder: self.$isUsernameFirstResponder, placeholder: self.$usernamePlaceHolder, isSecured: false, keyboard: .default)
                        .frame(height: 20)
                    
                    if self.isAvailable == 1 {
                        Image("green-check")
                    } else if self.isAvailable == 2 {
                        Image("red-x")
                            .onTapGesture {
                                self.textBindingManager.text = ""
                        }
                    }
                } // h
                    .padding()
                    .background(Capsule()
                        .fill(Color.white)
                        .border(Color.black))
            } // vstack
                .padding(.horizontal, 20)
        } // zstack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        TestUsername()
    }
}
