//
//  Pokedex3App.swift
//  Pokedex3
//
//  Created by Nuno Mendonça on 08/06/2023.
//

import SwiftUI

@main
struct Pokedex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
