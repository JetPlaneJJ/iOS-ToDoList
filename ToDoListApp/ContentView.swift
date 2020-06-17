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
    @State var input: String = ""
    @State private var items = UserDefaults.standard.stringArray(forKey: "todoList") ?? [String]()
    
    func addToList() {
        self.items.append(self.input)
        self.input = ""
        UserDefaults.standard.set(self.items, forKey: "todoList")
    }
    
    func removeFromList(name: String) {
        self.items = self.items.filter(){$0 != name}
        UserDefaults.standard.set(self.items, forKey: "todoList")
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("To-Do List")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
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
            List {
                if self.items.count != 0 {
                    ForEach(items, id: \.self) { item in
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
                    }
                }
            }
        }
        .padding(.top)
    }   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
