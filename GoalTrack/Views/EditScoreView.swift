import SwiftUI

struct EditScoreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameManager: GameManager
    
    let teamName: String
    let currentScore: Int
    let teamNumber: Int
    
    @State private var newScore: Int
    @FocusState private var isInputFocused: Bool
    
    init(teamName: String, currentScore: Int, teamNumber: Int) {
        self.teamName = teamName
        self.currentScore = currentScore
        self.teamNumber = teamNumber
        _newScore = State(initialValue: currentScore)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text(teamName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Current Score: \(currentScore)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Score Controls
                VStack(spacing: 25) {
                    // Large Score Display
                    Text("\(newScore)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .contentTransition(.numericText())
                    
                    // Plus/Minus Buttons
                    HStack(spacing: 40) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                if newScore > 0 {
                                    newScore -= 1
                                }
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(newScore > 0 ? .red : .gray)
                        }
                        .disabled(newScore <= 0)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                newScore += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Manual Entry
                    VStack(spacing: 8) {
                        Text("Or enter manually:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        TextField("Score", value: $newScore, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($isInputFocused)
                            .frame(width: 100)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // Save Button
                Button(action: {
                    gameManager.updateScore(for: teamNumber, newScore: max(0, newScore))
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .navigationTitle("Edit Score")
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
                            isInputFocused = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditScoreView(teamName: "Lax Plus", currentScore: 5, teamNumber: 1)
        .environmentObject(GameManager())
}
