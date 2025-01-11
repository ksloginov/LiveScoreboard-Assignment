import Foundation

// Match is a struct that represents a match between two teams
public struct Match: Equatable {
    let homeTeam: String
    let awayTeam: String
    let startTime: Date = Date() // We assume the match starts immediately once the struct is initiated. Alternatively, we could use `: Date?` & manually start the match.
    var homeScore: Int = 0 // UInt8 could be considered here; Default value for Int is 0;
    var awayScore: Int = 0

    var totalScore: Int {
        return homeScore + awayScore
    }
    
    func isTeamPlayingInMatch(_ team: String) -> Bool {
        return team == homeTeam || team == awayTeam
    }
}

extension Match: CustomStringConvertible {
    public var description: String {
        return "\(homeTeam) \(homeScore) - \(awayScore) \(awayTeam)"
    }
}
