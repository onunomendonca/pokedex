//
//  TempPokemon.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 27/08/2023.
//

import Foundation

struct TempPokemon: Codable {

    let id: Int
    let name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
    let sprite: URL
    let shiny: URL

    
}
