import SwiftUI

struct ActiveGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showingEditScore = false
    @State private var editingTeam: Int = 1
    @State private var showingEndGameAlert = false
    
    let game: Game
    
    var body: some View {
        VStack(spacing: 0) {
            // Score Display
            VStack(spacing: 30) {
                // Team 1
                TeamScoreCard(
                    teamName: game.team1Name,
                    score: game.team1Score,
                    color: .blue,
                    onIncrement: {
                        gameManager.incrementScore(for: 1)
                    },
                    onEdit: {
                        editingTeam = 1
                        showingEditScore = true
                    }
                )
                
                // VS Separator
                Text("VS")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
                
                // Team 2
                TeamScoreCard(
                    teamName: game.team2Name,
                    score: game.team2Score,
                    color: .orange,
                    onIncrement: {
                        gameManager.incrementScore(for: 2)
                    },
                    onEdit: {
                        editingTeam = 2
                        showingEditScore = true
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            Spacer()
            
            // End Game Button
            Button(action: {
                showingEndGameAlert = true
            }) {
                Text("End Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showingEditScore) {
            EditScoreView(
                teamName: editingTeam == 1 ? game.team1Name : game.team2Name,
                currentScore: editingTeam == 1 ? game.team1Score : game.team2Score,
                teamNumber: editingTeam
            )
        }
        .alert("End Game?", isPresented: $showingEndGameAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Game", role: .destructive) {
                gameManager.endCurrentGame()
            }
        } message: {
            Text("This will end the current game and save it to history. You can start a new game afterwards.")
        }
    }
}

struct TeamScoreCard: View {
    let teamName: String
    let score: Int
    let color: Color
    let onIncrement: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Team Name
            Text(teamName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            // Score and Controls
            HStack(spacing: 20) {
                // Score Display (tappable for edit)
                Button(action: onEdit) {
                    Text("\(score)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                        .frame(minWidth: 120)
                        .contentTransition(.numericText())
                }
                .buttonStyle(.plain)
                
                // Plus Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onIncrement()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(color)
                        .symbolEffect(.bounce, value: score)
                }
                .buttonStyle(.plain)
            }
            
            // Edit hint
            Text("Tap score to edit")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(25)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(color.opacity(0.3), lineWidth: 2)
                )
        )
    }
}

#Preview {
    let game = Game(team1Name: "Lax Plus", team2Name: "Red Giants")
    game.team1Score = 5
    game.team2Score = 3
    
    return ActiveGameView(game: game)
        .environmentObject(GameManager())
}
