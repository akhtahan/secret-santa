//
//  SecretSantaWidget.swift
//  SecretSantaWidget
//
//

import WidgetKit
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Provider: TimelineProvider {

        
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), user : User(id: "id", username: "john doe", name: "john doe") )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), user : User(id: "id", username: "john doe", name: "john doe") )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        if let sharedDefaults = UserDefaults(suiteName: "group.com.akhtahan.secretsanta"),
           let currentUserData = sharedDefaults.data(forKey: "USER"),
           let currentUser = try? JSONDecoder().decode(User.self, from: currentUserData) {
            // Use the currentUser object in your widget
        }
        
        var entries: [SimpleEntry] = []
        
        print("Entries: \(entries)")
        print("Timeline generated!")
        
        if let sharedDefaults = UserDefaults(suiteName: "group.com.akhtahan.secretsanta"),
           let currentUserData = sharedDefaults.data(forKey: "USER"),
           let currentUser = try? JSONDecoder().decode(User.self, from: currentUserData) {
            // Use the currentUser object to create a widget entry
            let entry = SimpleEntry(date: Date(), user: currentUser)

            entries.append(entry)

            // Create a timeline with the entry
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

        
    }


struct SimpleEntry: TimelineEntry {
    let date: Date
    let user : User
//    let name: String
//    let username: String
//    let secretSantaOf: String
}

struct SecretSantaWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🎅 Secret Santa Reminder")
                .font(.headline)
                .foregroundColor(.blue)

            Text(entry.user.name ?? "NA")
                .font(.subheadline)
                .foregroundColor(.primary)

            Text("Username: \(entry.user.username ?? "na")")
                .font(.subheadline)
                .foregroundColor(.primary)

            Text("Secret Santa of: \(entry.user.secretSantaOf ?? "na")")
                .font(.subheadline)
                .foregroundColor(.green)

            Spacer()
            
            Text(entry.date, style: .time)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct SecretSantaWidget: Widget {
    let kind: String = "SecretSantaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SecretSantaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
