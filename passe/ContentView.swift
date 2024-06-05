//
//  ContentView.swift
//  passe
//
//  Created by George Watson on 05/06/2024.
//

import SwiftUI

enum ViewState {
    case userState
    case passState
    case viewState
}

struct ContentView: View {
    @Environment(\.isFocused) private var isFocused: Bool
    let defaults = UserDefaults.standard
    @State var name: String = ""
    @State var pass: String = ""
    @State var site: String = ""
    @State var users = Array<String>()
    @State var sites = Array<String>()
    @State var showError = false
    @State var viewState: ViewState = .viewState
    @State var hidePassword = true
    
    var body: some View {
        VStack {
            Image(systemName: (self.viewState == .viewState ? "lock.open" : "lock"))
                .imageScale(.large)
                .foregroundStyle(.tint)
            switch self.viewState {
            case .userState:
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        TextField("", text: $name, prompt: Text("..."))
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                if !self.name.isEmpty {
                                    self.viewState = .passState
                                }
                            }
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
            case .passState:
                VStack(alignment: .leading) {
                    Text("Master Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        if self.hidePassword {
                            SecureField("Enter master password ...", text: $pass)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit { self.tryViewState() }
                        } else {
                            TextField("Enter master password ...", text: $pass)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit { self.tryViewState() }
                        }
                        Button(action: {
                            self.hidePassword = !self.hidePassword
                        }){
                            Image(systemName: (self.hidePassword ? "eye" : "eye.slash"))
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                        }
                    }
                }
            case .viewState:
                VStack(alignment: .leading) {
                    Text("Saved sites")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        TextField("", text: $site, prompt: Text("Name of site ..."))
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: self.site) {
                                // TODO: Update password label
                            }
                        Button(action: {
                            // TODO: Add site to list
                        }){
                            Text("+")
                        }
                    }
                }
                NavigationStack {
                    
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
            self.name = ""
            self.pass = ""
            self.viewState = .userState
        }
        .padding()
    }
    
    enum UserError: Error {
        case userAlreadyExists(name: String)
    }
    
    func tryViewState() {
        if !self.pass.isEmpty {
            self.updateSites()
            self.viewState = .viewState
        }
    }
    
    func updateUsers() {
        let dict: [String:Array<String>]? = self.defaults.object(forKey: "users") as? [String:Array<String>]? ?? nil
        if dict == nil {
            self.defaults.set([:] as [String:Array<String>], forKey: "users")
        }
        self.users = Array(self.defaults.dictionary(forKey: "users")!.keys.sorted())
        self.defaults.synchronize()
    }
    
    func updateSites() {
        if let dict: [String:Array<String>] = self.defaults.object(forKey: "users") as? [String:Array<String>] {
            if let sites: Array<String> = dict[self.name] {
                self.sites = sites
            }
        }
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
