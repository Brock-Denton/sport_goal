import SwiftUI
import WidgetKit

struct GameWidgetView: View {
    let game: GameData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header
            HStack {
                Image(systemName: "sportscourt.fill")
                    .font(.caption2)
                    .foregroundColor(.blue)
                Text("LIVE")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.green)
                Spacer()
            }
            
            // Team 1
            HStack {
                Text(game.team1Name)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Text("\(game.team1Score)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            }
            
            // Divider
            Divider()
                .padding(.vertical, 1)
            
            // Team 2
            HStack {
                Text(game.team2Name)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                Text("\(game.team2Score)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
}
