//
//  PokeDexApp.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 27/08/2023.
//

import SwiftUI

@main
struct PokeDexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
