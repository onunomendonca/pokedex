//
//  PokemonViewModel.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 28/08/2023.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {

    enum Status {

        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }

    //Private on set but everyone else can get it
    @Published private(set) var status = Status.notStarted

    private let controller: FetchController

    init(controller: FetchController) {

        self.controller = controller

        Task {
            await self.getPokemon()
        }
    }

    private func getPokemon() async {

        status = .fetching

        do {

            guard var pokedex = try await controller.fetchAllPokemon() else {

                print("Pokemon have already been got. We good.")
                status = .success
                return
            }
            pokedex.sort { $0.id < $1.id }

            //Write Pokemon in CoreData
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false

                try PersistenceController.shared.container.viewContext.save()
            }

            status = .success

        } catch {

            status = .failed(error: error)
        }
    }
}
