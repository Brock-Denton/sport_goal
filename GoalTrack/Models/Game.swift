import Foundation
import SwiftData

@Model
final class Game {
    var id: UUID
    var team1Name: String
    var team2Name: String
    var team1Score: Int
    var team2Score: Int
    var isActive: Bool
    var date: Date
    
    init(team1Name: String, team2Name: String) {
        self.id = UUID()
        self.team1Name = team1Name
        self.team2Name = team2Name
        self.team1Score = 0
        self.team2Score = 0
        self.isActive = true
        self.date = Date()
    }
    
    func incrementTeam1Score() {
        team1Score += 1
    }
    
    func incrementTeam2Score() {
        team2Score += 1
    }
    
    func decrementTeam1Score() {
        if team1Score > 0 {
            team1Score -= 1
        }
    }
    
    func decrementTeam2Score() {
        if team2Score > 0 {
            team2Score -= 1
        }
    }
    
    func endGame() {
        isActive = false
    }
}

// Extension for widget data sharing
extension Game {
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "team1Name": team1Name,
            "team2Name": team2Name,
            "team1Score": team1Score,
            "team2Score": team2Score,
            "isActive": isActive,
            "date": date.timeIntervalSince1970
        ]
    }
    
    static func fromDictionary(_ dict: [String: Any]) -> Game? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let team1Name = dict["team1Name"] as? String,
              let team2Name = dict["team2Name"] as? String,
              let team1Score = dict["team1Score"] as? Int,
              let team2Score = dict["team2Score"] as? Int,
              let isActive = dict["isActive"] as? Bool,
              let dateInterval = dict["date"] as? TimeInterval else {
            return nil
        }
        
        let game = Game(team1Name: team1Name, team2Name: team2Name)
        game.id = id
        game.team1Score = team1Score
        game.team2Score = team2Score
        game.isActive = isActive
        game.date = Date(timeIntervalSince1970: dateInterval)
        return game
    }
}
