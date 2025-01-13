import Foundation

// I intentionally opted to go for `DispatchQueue` over `actor` to make the libarary more flexible and compatible with older versions of Swift.
public final class Scoreboard {
    
    private var matches: [Match] = []
    private let queue = DispatchQueue(label: "ScoreboardQueue", attributes: .concurrent)

    public init() {}

    /// Starts a new match between two teams with a score of 0-0.
    ///
    /// This method ensures that the team names are not empty or equal, and verifies that the teams are not already playing in another match.
    /// If all checks pass, it adds a new match to the scoreboard.
    ///
    /// - Parameters:
    ///   - homeTeam: The name of the home team.
    ///   - awayTeam: The name of the away team.
    /// - Throws:
    ///   - `ScoreboardError.invalidTeamName` if the team names are invalid (empty or identical).
    ///   - `ScoreboardError.teamAlreadyInMatch` if either team is already playing in another match.
    public func startMatch(homeTeam: String, awayTeam: String) throws {
        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        // Verifying the the team names are not equal and not empty (spaces could be trimmed while normalizaing)
        guard !normalizedHomeTeam.isEmpty, !normalizedAwayTeam.isEmpty, normalizedHomeTeam != normalizedAwayTeam else {
            throw ScoreboardError.invalidTeamName
        }
        
        try queue.sync(flags: .barrier) {
            // Verifying that the teams are not playing right now
            guard !matches.contains(where: {$0.isTeamPlayingInMatch(normalizedHomeTeam) || $0.isTeamPlayingInMatch(normalizedAwayTeam)}) else {
                throw ScoreboardError.teamAlreadyInMatch
            }

            // Creating a new match and adding it to the matches array
            matches.append(Match(homeTeam: normalizedHomeTeam, awayTeam: normalizedAwayTeam))
        }
    }

    /// Finishes a match by removing it from the scoreboard.
    ///
    /// This method looks for a match by the exact order of home and away teams.
    /// If the match is found, it will be removed. If the match cannot be found, an error will be thrown.
    ///
    /// - Parameters:
    ///   - homeTeam: The name of the home team.
    ///   - awayTeam: The name of the away team.
    /// - Throws:
    ///   - `ScoreboardError.matchNotFound` if the match with the specified teams does not exist.
    public func finishMatch(homeTeam: String, awayTeam: String) throws {
        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        try queue.sync(flags: .barrier) {
            // We consider input as order-sensitive: we need to find the match with the exact order of home and away teams
            guard let matchIndex = matches.firstIndex(where: {
                $0.homeTeam == normalizedHomeTeam && $0.awayTeam == normalizedAwayTeam }) else {
                throw ScoreboardError.matchNotFound
            }

            matches.remove(at: matchIndex)
        }
    }

    /// Updates the score for a given match.
    ///
    /// This method updates the score for the specified home and away teams.
    /// The scores cannot be negative and must be valid. If the match is not found, an error is thrown.
    ///
    /// - Parameters:
    ///   - homeTeam: The name of the home team.
    ///   - awayTeam: The name of the away team.
    ///   - homeScore: The new score for the home team.
    ///   - awayScore: The new score for the away team.
    /// - Throws:
    ///   - `ScoreboardError.matchNotFound` if the match is not found.
    ///   - `ScoreboardError.invalidScore` if the scores are negative.
    public func updateScore(homeTeam: String, awayTeam: String, homeScore: Int, awayScore: Int) throws {
        guard homeScore >= 0 && awayScore >= 0 else {
            throw ScoreboardError.invalidScore
        }

        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        try queue.sync(flags: .barrier) {
            // We consider input as order-sensitive: we need to find the match with the exact order of home and away teams
            guard let matchIndex = matches.firstIndex(where: {$0.homeTeam == normalizedHomeTeam && $0.awayTeam == normalizedAwayTeam}) else {
                throw ScoreboardError.matchNotFound
            }

            matches[matchIndex].homeScore = homeScore
            matches[matchIndex].awayScore = awayScore
        }
    }

    /// Returns a sorted list of matches currently in progress.
    ///
    /// The matches are sorted by their total score, with the highest total score appearing first. If two matches have the same total score,
    /// they are ordered by the most recently started match.
    ///
    /// - Returns: A list of `Match` objects sorted by total score and start time.
    public func getSummary() -> [Match] {
        return queue.sync { matches.sorted {
                if $0.totalScore == $1.totalScore {
                    return $0.startTime > $1.startTime
                }

                return $0.totalScore > $1.totalScore
            }
        }
    }
}

extension Scoreboard {
    // Assuming team names are case-insensitive, we want to normalize them to lowercase and capitalize the first letter of each word (to display them in a consistent way)
    func normalizeTeamName(_ teamName: String) -> String {
        return teamName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().capitalized
    }
}
