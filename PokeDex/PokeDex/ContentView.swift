//
//  ContentView.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 27/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //Access viewContext of our environment (App)
    @Environment(\.managedObjectContext) private var viewContext

    //To Get the data from the DB. It's not like a table/spreadsheet.
    //CoreData is a graph. They are nodes and they are linked between them.
    //We sort the data from the time.
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)], animation: .default) private var pokedex: FetchedResults<Pokemon>

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
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
