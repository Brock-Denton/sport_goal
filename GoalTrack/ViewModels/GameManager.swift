import Foundation
import SwiftUI
import SwiftData
import WidgetKit

@MainActor
class GameManager: ObservableObject {
    @Published var activeGame: Game?
    @Published var games: [Game] = []
    
    let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private let appGroupID = "group.com.goaltrack.shared"
    
    init() {
        do {
            // Configure SwiftData with App Group container
            let schema = Schema([Game.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                groupContainer: .identifier(appGroupID)
            )
            
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            modelContext = ModelContext(modelContainer)
            
            loadGames()
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    func loadGames() {
        let descriptor = FetchDescriptor<Game>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            games = try modelContext.fetch(descriptor)
            activeGame = games.first(where: { $0.isActive })
            
            // Share active game with widget
            if let activeGame = activeGame {
                shareActiveGameWithWidget(activeGame)
            }
        } catch {
            print("Failed to fetch games: \(error)")
        }
    }
    
    func createGame(team1: String, team2: String) {
        // End any existing active game
        if let currentActive = activeGame {
            currentActive.endGame()
        }
        
        let newGame = Game(team1Name: team1, team2Name: team2)
        modelContext.insert(newGame)
        
        do {
            try modelContext.save()
            activeGame = newGame
            games.insert(newGame, at: 0)
            shareActiveGameWithWidget(newGame)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save game: \(error)")
        }
    }
    
    func incrementScore(for team: Int) {
        guard let game = activeGame else { return }
        
        if team == 1 {
            game.incrementTeam1Score()
        } else {
            game.incrementTeam2Score()
        }
        
        saveGame()
    }
    
    func decrementScore(for team: Int) {
        guard let game = activeGame else { return }
        
        if team == 1 {
            game.decrementTeam1Score()
        } else {
            game.decrementTeam2Score()
        }
        
        saveGame()
    }
    
    func updateScore(for team: Int, newScore: Int) {
        guard let game = activeGame else { return }
        
        if team == 1 {
            game.team1Score = max(0, newScore)
        } else {
            game.team2Score = max(0, newScore)
        }
        
        saveGame()
    }
    
    func endCurrentGame() {
        guard let game = activeGame else { return }
        
        game.endGame()
        saveGame()
        
        activeGame = nil
        clearWidgetData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func saveGame() {
        do {
            try modelContext.save()
            if let game = activeGame {
                shareActiveGameWithWidget(game)
                WidgetCenter.shared.reloadAllTimelines()
            }
        } catch {
            print("Failed to save game: \(error)")
        }
    }
    
    private func shareActiveGameWithWidget(_ game: Game) {
        guard let userDefaults = UserDefaults(suiteName: appGroupID) else {
            print("Failed to access App Group UserDefaults")
            return
        }
        
        let gameData = game.toDictionary()
        userDefaults.set(gameData, forKey: "activeGame")
        userDefaults.synchronize()
    }
    
    private func clearWidgetData() {
        guard let userDefaults = UserDefaults(suiteName: appGroupID) else { return }
        userDefaults.removeObject(forKey: "activeGame")
        userDefaults.synchronize()
    }
}
