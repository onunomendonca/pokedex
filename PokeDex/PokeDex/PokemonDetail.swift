//
//  PokemonDetail.swift
//  PokeDex
//
//  Created by Nuno Mendonça on 28/08/2023.
//

import CoreData
import SwiftUI

struct PokemonDetail: View {

    //Access viewContext of our environment (App)
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var pokemon: Pokemon
    @State private var showShiny = false

    var body: some View {
        ScrollView {

            ZStack {

                Image(self.pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)

                AsyncImage(url: self.showShiny ? self.pokemon.shiny : self.pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)

                } placeholder: {

                    ProgressView()
                }
            }

            HStack {

                ForEach(self.pokemon.types!, id: \.self) { type in

                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }

                Spacer()

                Button {
                    withAnimation {

                        self.pokemon.favorite.toggle()

                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    Image(systemName: self.pokemon.favorite ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                        .font(.title)
                }
            }
            .padding()

            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)

            StatsView()
                .environmentObject(self.pokemon) // it needs to know which pokemon we are watching
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {

                Button {

                    self.showShiny.toggle()
                } label: {

                    if self.showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }

            }
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {

        PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
