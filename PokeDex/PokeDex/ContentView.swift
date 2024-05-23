//
//  ContentView.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 27/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())

    //To Get the data from the DB. It's not like a table/spreadsheet.
    //CoreData is a graph. They are nodes and they are linked between them.
    //We sort the data from the time.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    //Only fetch those who are favorite.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    )
    private var favorites: FetchedResults<Pokemon>

    @State var filterByFavorites = false

    var body: some View {
        switch pokemonVM.status {

        case .success:
            NavigationStack {
                List(self.filterByFavorites ? self.favorites : self.pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        Text(pokemon.name!.capitalized)

                        if pokemon.favorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokédex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Filter by Favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundStyle(.yellow)
                    }
                    
                }
            }

        default:
            ProgressView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
