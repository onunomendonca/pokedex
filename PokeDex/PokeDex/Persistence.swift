//
//  Persistence.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 27/08/2023.
//

import CoreData

struct PersistenceController {
    //We want a shared persistenceController so we always use the same Controller.
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    //We don't want the real data to be changed by the preview data.
    //This is what is shown when we preview the data in the Xcode UI.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        // Result is a truck full of stuff;
        // The truck can have multiple boxes/containers/compartments/sections. Each have stuff.:
        // ViewContext is what is inside the box. It's the shelf. (it is the detail).
        let viewContext = result.container.viewContext
        let samplePokemon = Pokemon(context: viewContext)
        samplePokemon.id = 1
        samplePokemon.name = "Bulbasur"
        samplePokemon.types = ["grass","poison"]
        samplePokemon.hp = 45
        samplePokemon.attack = 49
        samplePokemon.defense = 49
        samplePokemon.specialAttack = 65
        samplePokemon.specialDefense = 65
        samplePokemon.defense = 65
        samplePokemon.speed = 45
        samplePokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        samplePokemon.favorite = false

        do {
            //So data can be persisted when we close the app:
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        //We have the container called PokeDex:
        container = NSPersistentContainer(name: "PokeDex")
        if inMemory {
            //To check if data exists. If so, get it.
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        //Load the data.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
