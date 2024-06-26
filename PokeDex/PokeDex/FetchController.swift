//
//  FetchController.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 28/08/2023.
//

import Foundation
import CoreData

struct FetchController {

    enum NetworkError: Error {

        case badURL, badResponse, badData
    }

    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!

    func fetchAllPokemon() async throws -> [TempPokemon]? {

        if self.havePokemon() {

            return nil
        }
        
        var allPokemon: [TempPokemon] = []

        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        //We get the first three generations, hence why the 386.
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]

        guard let fetchURL = fetchComponents?.url else {

            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: fetchURL)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

            throw NetworkError.badResponse
        }

        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let pokeDex = pokeDictionary["results"] as? [[String:String]] else {

            throw NetworkError.badData
        }

        for pokemon in pokeDex {

            if let url = pokemon["url"] {

                allPokemon.append(try await self.fetchPokemon(from: URL(string: url)!))
            }
        }

        return allPokemon
    }

    //We need this because the API gives us the URL for the Pokemon ID XX.
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

            throw NetworkError.badResponse
        }

        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)

        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")

        return tempPokemon
    }

    private func havePokemon() -> Bool {

        // Check if there are pokemons in the background.
        let context = PersistenceController.shared.container.newBackgroundContext()

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        //I wanna fetch the pokemon that has an ID of 1 to 386
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])

        do {
            let checkPokemon = try context.fetch(fetchRequest)
            return checkPokemon.count == 2 ? true : false
        } catch {
            print("Fetch Failed: \(error)")
            return false
        }
    }
}
