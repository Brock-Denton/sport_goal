import SwiftUI

struct CreateGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    
    @State private var team1Name = ""
    @State private var team2Name = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case team1, team2
    }
    
    var isFormValid: Bool {
        !team1Name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !team2Name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Team 1 Name", text: $team1Name)
                        .focused($focusedField, equals: .team1)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .team2
                        }
                    
                    TextField("Team 2 Name", text: $team2Name)
                        .focused($focusedField, equals: .team2)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .onSubmit {
                            if isFormValid {
                                createGame()
                            }
                        }
                } header: {
                    Text("Game Details")
                } footer: {
                    Text("Enter the names of both teams (e.g., \"Lax Plus\" vs \"Red Giants\")")
                }
                
                Section {
                    Button(action: createGame) {
                        HStack {
                            Spacer()
                            Text("Create Game")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
            .onAppear {
                focusedField = .team1
            }
        }
    }
    
    private func createGame() {
        let team1 = team1Name.trimmingCharacters(in: .whitespaces)
        let team2 = team2Name.trimmingCharacters(in: .whitespaces)
        
        gameManager.createGame(team1: team1, team2: team2)
        dismiss()
    }
}

#Preview {
    CreateGameView()
        .environmentObject(GameManager())
}
