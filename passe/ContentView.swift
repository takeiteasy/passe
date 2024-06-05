//
//  ContentView.swift
//  passe
//
//  Created by George Watson on 05/06/2024.
//

import SwiftUI

struct ContentView: View {
    let defaults = UserDefaults.standard
    @State var name: String = ""
    @State var users = Array<String>()
    @State var showError = false
    
    var body: some View {
        VStack {
            Image(systemName: "lock")
                .imageScale(.large)
                .foregroundStyle(.tint)
            VStack(alignment: .leading) {
                Text("Name").font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    TextField("", text: $name, prompt: Text("..."))
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        if !self.name.trimmingCharacters(in: .whitespaces).isEmpty {
                            do {
                                try self.addUser(user: name)
                            } catch UserError.userAlreadyExists {
                                self.showError = true
                            } catch {}
                            self.name = ""
                        }
                    }){
                        Text("+")
                    }
                }
                if self.showError {
                    Text("That user already exists!")
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showError = false
                            }
                        })
                }
            }
            NavigationStack {
                List {
                    ForEach($users, id: \.self) { $user in
                        Text(user)
                            .onTapGesture {
                                self.name = user
                            }
                            .contextMenu {
                                Button(action: {
                                    if let idx = self.users.firstIndex(of: user) {
                                        self.deleteUser(at: IndexSet(integer: idx))
                                    }
                                }){
                                    Text("Delete")
                                }
                            }
                    }
                    .onDelete(perform: deleteUser)
                }
                .cornerRadius(10)
            }
            .onAppear(perform: {
                self.defaults.synchronize()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateUsers()
                }
            })
        }
        .padding()
    }
    
    enum UserError: Error {
        case userAlreadyExists(name: String)
    }
    
    func updateUsers() {
        let dict: [String:Array<String>]? = self.defaults.object(forKey: "users") as? [String:Array<String>]? ?? nil
        if dict == nil {
            self.defaults.set([:] as [String:Array<String>], forKey: "users")
        }
        self.users = Array(self.defaults.dictionary(forKey: "users")!.keys.sorted())
        self.defaults.synchronize()
    }
    
    func addUser(user: String) throws {
        var dict = self.defaults.object(forKey: "users") as! [String:Array<String>]
        if let _ = dict[user] {
            throw UserError.userAlreadyExists(name: user)
        } else {
            dict[user] = Array<String>()
            self.defaults.set(dict, forKey: "users")
            self.updateUsers()
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let user = self.users[index]
        var dict = self.defaults.object(forKey: "users") as! [String:Array<String>]
        if let _ = dict[user] {
            dict.removeValue(forKey: user)
            self.defaults.set(dict, forKey: "users")
            self.updateUsers()
        }
    }
}

#Preview {
    ContentView()
}
