import Foundation

// Match is a struct that represents a match between two teams
public struct Match {
    let homeTeam: String
    let awayTeam: String
    // We assume the match starts immediately once the struct is initiated.
    // Alternatively, we could use `: Date?` & manually start the match.
    let startTime: Date
    var homeScore: Int // UInt8 could be considered here; Default value for Int is 0;
    var awayScore: Int

    init(homeTeam: String, awayTeam: String, timeProvider: TimeProvider = .live, homeScore: Int = 0, awayScore: Int = 0) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.startTime = timeProvider.date()
        self.homeScore = homeScore
        self.awayScore = awayScore
    }

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
