import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showingCreateGame = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let activeGame = gameManager.activeGame {
                    ActiveGameView(game: activeGame)
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "sportscourt.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("No Active Game")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Create a new game to start tracking scores")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showingCreateGame = true
                        }) {
                            Label("Create Game", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Goal Track")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: GameHistoryView()) {
                        Image(systemName: "clock.fill")
                    }
                }
                
                if gameManager.activeGame == nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingCreateGame = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreateGame) {
                CreateGameView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameManager())
}
