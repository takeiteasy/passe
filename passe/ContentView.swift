//
//  ContentView.swift
//  passe
//
//  Created by George Watson on 05/06/2024.
//

import SwiftUI

enum ViewState {
    case userState // Enter username state
    case passState // Enter password state
    case viewState // View passwords state
}

struct SitePassword: Identifiable {
    let id = UUID()
    var site: String
    var pass: String
}

struct ContentView: View {
    @Environment(\.isFocused) private var isFocused: Bool
    let defaults = UserDefaults.standard
    @State var name = ""
    @State var pass = ""
    @State var site = ""
    @State var users = Array<String>()
    @State var sites = Array<SitePassword>()
    @State var siteSelection: SitePassword.ID?
    @State var showError = false
    @State var viewState: ViewState = .userState
    @State var hidePassword = true
    @State var passBuffer = ""
    
    var body: some View {
        VStack {
            Image(systemName: (self.viewState == .viewState ? "lock.open" : "lock"))
                .imageScale(.large)
                .foregroundStyle(.tint)
            switch self.viewState {
            case .userState: // Enter username state
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                        .frame(maxWidth: .infinity,
                               alignment: .center)
                    HStack {
                        // TODO: On enter, make text field focused (for each state)
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
                            .frame(maxWidth: .infinity,
                                   alignment: .center)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showError = false
                                }
                            })
                    }
                }
                NavigationStack {
                    if !self.users.isEmpty {
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
                }
                .onAppear(perform: {
                    self.defaults.synchronize()
                    // Brief pause to allow UI to update, prevents list not being
                    // the right size when the window opens for the first time
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.updateUsers()
                    }
                })
            case .passState: // Enter password state
                VStack(alignment: .leading) {
                    Text("Master Password for \(self.name)")
                        .font(.headline)
                        .frame(maxWidth: .infinity,
                               alignment: .center)
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
            case .viewState: // View passwords state
                VStack(alignment: .leading) {
                    Text("Saved sites for \(self.name)")
                        .font(.headline)
                        .frame(maxWidth: .infinity,
                               alignment: .center)
                    HStack {
                        TextField("", text: $site, prompt: Text("Name of site ..."))
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: self.site) {
                                self.passBuffer = self.site.isEmpty ? "" : GeneratePassword(name: self.name, password: self.pass, site: self.site) ?? ""
                            }
                        Button(action: {
                            if !self.site.trimmingCharacters(in: .whitespaces).isEmpty {
                                try! self.addSite(user: self.name, site: self.site)
                                self.updateSites()
                                self.site = ""
                                self.passBuffer = ""
                            }
                        }){
                            Text("+")
                        }
                    }
                    if !self.passBuffer.isEmpty {
                        Text(self.passBuffer)
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .font(.system(size: 36))
                            .frame(maxWidth: .infinity,
                                   alignment: .center)
                    }
                }
                NavigationStack {
                    // TODO: Table entry on click, copy to clipboard
                    // TODO: Delete site from user
                    if !self.sites.isEmpty {
                        Table(sites, selection: $siteSelection) {
                            TableColumn("Site", value: \.site)
                            TableColumn("Password") { sp in
                                Text(String(sp.pass))
                            }
                        }
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
            // TODO: Add a timer to only clear data+state if past timeout
            self.name = ""
            self.pass = ""
            self.site = ""
            self.viewState = .userState
        }
        .padding()
    }
    
    enum UserError: Error {
        case userAlreadyExists(name: String)
        case userDoesntExist(name: String)
    }
    
    func tryViewState() {
        if !self.pass.trimmingCharacters(in: .whitespaces).isEmpty {
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
                self.sites = []
                for site in sites {
                    let pass = GeneratePassword(name: self.name,
                                                password: self.pass,
                                                site: site)!
                    self.sites.append(SitePassword(site: site, pass: pass))
                }
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
    
    func addSite(user: String, site: String) throws {
        var dict = self.defaults.object(forKey: "users") as! [String:Array<String>]
        if var arr: Array<String> = dict[user] {
            if arr.firstIndex(of: site) == nil {
                arr.append(site)
                dict[user] = arr
                self.defaults.set(dict, forKey: "users")
                self.updateUsers()
            }
        } else {
            throw UserError.userDoesntExist(name: user)
        }
    }
}

#Preview {
    ContentView()
}
