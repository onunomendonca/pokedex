//
//  PokeDexWidget.swift
//  PokeDexWidget
//
//  Created by Nuno Mendonça on 24/05/2024.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {

    var randomPokemon: Pokemon {

        let context = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()

        var results: [Pokemon] = []

        do {

            results = try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch pokemons. \(error)")
        }

        if let randomPokemon = results.randomElement() {

            return randomPokemon
        } else {

            return SamplePokemon.samplePokemon
        }
    }

    //Placeholder before showing the widget.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), pokemon: SamplePokemon.samplePokemon)
    }

    //Single shot of the widget. This is what you want to show forever, unless you use a timeline \/
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), pokemon: self.randomPokemon)
        completion(entry)
    }

    //Each entry is going to show on the widget and how many times is it going to switch through. Literally creates a timeline.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, pokemon: self.randomPokemon)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let pokemon: Pokemon
}

//Widget View.
struct PokeDexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {

        case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)

        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
                .environmentObject(entry.pokemon)

        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)

        default:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

//What runs the widget.
struct PokeDexWidget: Widget {
    let kind: String = "PokeDexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PokeDexWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PokeDexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PokeDexWidget()
} timeline: {
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemMedium) {
    PokeDexWidget()
} timeline: {
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemLarge) {
    PokeDexWidget()
} timeline: {
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, pokemon: SamplePokemon.samplePokemon)
}
