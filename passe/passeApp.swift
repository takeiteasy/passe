//
//  passeApp.swift
//  passe
//
//  Created by George Watson on 05/06/2024.
//

import SwiftUI

@main
struct PasseApp: App {
    var body: some Scene {
        MenuBarExtra("Passe", systemImage: "lock") {
            ContentView()
        }.menuBarExtraStyle(.window)
        WindowGroup {}
    }
}

