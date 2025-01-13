import Foundation

public struct Scoreboard {

    private var matches: [Match] = []

    public init() {}

    public mutating func startMatch(homeTeam: String, awayTeam: String) throws {
        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        // Verifying the the team names are not equal and not empty (spaces could be trimmed while normalizaing)
        guard !normalizedHomeTeam.isEmpty, !normalizedAwayTeam.isEmpty, normalizedHomeTeam != normalizedAwayTeam else {
            throw ScoreboardError.invalidTeamName
        }

        // Verifying that the teams are not playing right now
        guard !matches.contains(where: {$0.isTeamPlayingInMatch(normalizedHomeTeam) || $0.isTeamPlayingInMatch(normalizedAwayTeam)}) else {
            throw ScoreboardError.teamAlreadyInMatch
        }

        // Creating a new match and adding it to the matches array
        matches.append(Match(homeTeam: normalizedHomeTeam, awayTeam: normalizedAwayTeam))
    }

    public mutating func finishMatch(homeTeam: String, awayTeam: String) throws {
        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        // We consider input as order-sensitive: we need to find the match with the exact order of home and away teams
        guard let matchIndex = matches.firstIndex(where: {
            $0.homeTeam == normalizedHomeTeam && $0.awayTeam == normalizedAwayTeam }) else {
            throw ScoreboardError.matchNotFound
        }

        matches.remove(at: matchIndex)
    }

    public mutating func updateScore(homeTeam: String, awayTeam: String, homeScore: Int, awayScore: Int) throws {
        guard homeScore >= 0 && awayScore >= 0 else {
            throw ScoreboardError.invalidScore
        }

        let normalizedHomeTeam = normalizeTeamName(homeTeam)
        let normalizedAwayTeam = normalizeTeamName(awayTeam)

        // We consider input as order-sensitive: we need to find the match with the exact order of home and away teams
        guard let matchIndex = matches.firstIndex(where: {$0.homeTeam == normalizedHomeTeam && $0.awayTeam == normalizedAwayTeam}) else {
            throw ScoreboardError.matchNotFound
        }

        matches[matchIndex].homeScore = homeScore
        matches[matchIndex].awayScore = awayScore
    }

    public func getSummary() -> [Match] {
        return matches.sorted {
            if $0.totalScore == $1.totalScore {
                return $0.startTime > $1.startTime
            }

            return $0.totalScore > $1.totalScore
        }
    }
}

extension Scoreboard {
    // Assuming team names are case-insensitive, we want to normalize them to lowercase and capitalize the first letter of each word (to display them in a consistent way)
    func normalizeTeamName(_ teamName: String) -> String {
        return teamName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().capitalized
    }
}
