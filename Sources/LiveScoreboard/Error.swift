import Foundation

enum ScoreboardError: Error {
    case matchNotFound
    case teamAlreadyInMatch
    case invalidScore
    case invalidTeamName
}
