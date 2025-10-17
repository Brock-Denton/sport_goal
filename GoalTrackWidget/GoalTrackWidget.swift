import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let appGroupID = "group.com.goaltrack.shared"
    
    func placeholder(in context: Context) -> GameEntry {
        GameEntry(date: Date(), game: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (GameEntry) -> ()) {
        let entry = GameEntry(date: Date(), game: loadActiveGame())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = GameEntry(date: currentDate, game: loadActiveGame())
        
        // Refresh every 5 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func loadActiveGame() -> GameData? {
        guard let userDefaults = UserDefaults(suiteName: appGroupID),
              let gameDict = userDefaults.dictionary(forKey: "activeGame") else {
            return nil
        }
        
        guard let team1Name = gameDict["team1Name"] as? String,
              let team2Name = gameDict["team2Name"] as? String,
              let team1Score = gameDict["team1Score"] as? Int,
              let team2Score = gameDict["team2Score"] as? Int,
              let isActive = gameDict["isActive"] as? Bool,
              isActive else {
            return nil
        }
        
        return GameData(
            team1Name: team1Name,
            team2Name: team2Name,
            team1Score: team1Score,
            team2Score: team2Score
        )
    }
}

struct GameEntry: TimelineEntry {
    let date: Date
    let game: GameData?
}

struct GameData {
    let team1Name: String
    let team2Name: String
    let team1Score: Int
    let team2Score: Int
}

struct GoalTrackWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if let game = entry.game {
            GameWidgetView(game: game)
        } else {
            NoGameView()
        }
    }
}

struct NoGameView: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "sportscourt")
                .font(.title3)
                .foregroundColor(.secondary)
            Text("No Active Game")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@main
struct GoalTrackWidget: Widget {
    let kind: String = "GoalTrackWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GoalTrackWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Game Tracker")
        .description("Track your tournament game scores")
        .supportedFamilies([.accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    GoalTrackWidget()
} timeline: {
    GameEntry(date: .now, game: GameData(
        team1Name: "Lax Plus",
        team2Name: "Red Giants",
        team1Score: 5,
        team2Score: 3
    ))
    GameEntry(date: .now, game: nil)
}
