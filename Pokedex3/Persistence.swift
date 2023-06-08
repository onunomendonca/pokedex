//
//  Persistence.swift
//  Pokedex3
//
//  Created by Nuno Mendonça on 08/06/2023.
//

import CoreData

struct PersistenceController {
    //We want a shared persistenceController so we always use the same Controller.
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    //This is apart from the PersistenceController so we can see how our app is gonna look.
    // When we use real data we won't use this. This is a sample so we can see on the Preview Tab.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        //The new item
        let samplePokemon = Pokemon(context: viewContext)
        samplePokemon.id = 1
        samplePokemon.name = "bulbasaur"
        samplePokemon.types = ["grass", "poison"]
        samplePokemon.hp = 45
        samplePokemon.attack = 49
        samplePokemon.defense = 49
        samplePokemon.specialAttack = 65
        samplePokemon.specialDefense = 65
        samplePokemon.speed = 45
        samplePokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        samplePokemon.favorite = false
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        //We have a container
        container = NSPersistentContainer(name: "Pokedex3")
        if inMemory {
            //and we save them
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
