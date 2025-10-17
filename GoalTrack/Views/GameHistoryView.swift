import SwiftUI

struct GameHistoryView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var completedGames: [Game] {
        gameManager.games.filter { !$0.isActive }
    }
    
    var body: some View {
        List {
            if completedGames.isEmpty {
                ContentUnavailableView(
                    "No Game History",
                    systemImage: "clock",
                    description: Text("Completed games will appear here")
                )
            } else {
                ForEach(completedGames, id: \.id) { game in
                    GameHistoryRow(game: game)
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameHistoryRow: View {
    let game: Game
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: game.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Teams and Scores
            HStack(spacing: 15) {
                // Team 1
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.team1Name)
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("\(game.team1Score)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(game.team1Score > game.team2Score ? .blue : .secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // VS
                Text("VS")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
                
                // Team 2
                VStack(alignment: .trailing, spacing: 4) {
                    Text(game.team2Name)
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text("\(game.team2Score)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(game.team2Score > game.team1Score ? .orange : .secondary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Winner Badge
            if game.team1Score != game.team2Score {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.caption)
                    Text("\(game.team1Score > game.team2Score ? game.team1Name : game.team2Name) Won")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(game.team1Score > game.team2Score ? .blue : .orange)
            } else {
                HStack {
                    Image(systemName: "equal.circle.fill")
                        .font(.caption)
                    Text("Tie Game")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        GameHistoryView()
            .environmentObject(GameManager())
    }
}
