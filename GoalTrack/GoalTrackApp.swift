import SwiftUI
import SwiftData

@main
struct GoalTrackApp: App {
    @StateObject private var gameManager = GameManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
        }
        .modelContainer(gameManager.modelContainer)
    }
}
