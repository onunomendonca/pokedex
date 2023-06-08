//
//  ContentView.swift
//  Pokedex3
//
//  Created by Nuno Mendonça on 08/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //Access viewContext of our environment (App)
    @Environment(\.managedObjectContext) private var viewContext

    //To get our data from the Persistence. Ascending true: New values go to the bottom.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default) private var pokedex: FetchedResults<Pokemon>

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        Text("\(pokemon.id): \(pokemon.name!.capitalized)")
                    } label: {
                        Text("\(pokemon.id): \(pokemon.name!.capitalized)")
                    }
                }
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //Here we use the preview, so we can preview on the sim.
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
