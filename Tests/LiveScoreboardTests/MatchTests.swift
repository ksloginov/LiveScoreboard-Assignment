import Testing
import Foundation
@testable import LiveScoreboard

@Test func test_initialization_setsCorrectProperties() async throws {
    // Given
    let homeTeam = "Argentina"
    let awayTeam = "Brazil"
    
    // When
    let match = Match(homeTeam: homeTeam, awayTeam: awayTeam)
    
    // Then
    #expect(match.homeTeam == "Argentina")
    #expect(match.homeTeam == "Argentina")
    #expect(match.awayTeam == "Brazil")
    #expect(match.homeScore == 0)
    #expect(match.awayScore == 0)
    #expect(match.startTime != nil)
    
    try await Task.sleep(for: .milliseconds(100))
    #expect(match.startTime < Date())
    #expect(match.startTime > Date().addingTimeInterval(-1.0))
}

@Test func test_isTeamPlayingInMatch_returnsTrueIfTeamIsPlaying() {
    // Given
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil")
    
    // When/Then
    #expect(match.isTeamPlayingInMatch("Argentina"))
    #expect(match.isTeamPlayingInMatch("Brazil"))
    #expect(!match.isTeamPlayingInMatch("Germany"))
}

@Test func test_totalScore_returnsSumOfScores() {
    // Given
    var match = Match(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)
    
    // When
    let totalScore = match.totalScore
    
    // Then
    #expect(totalScore == 5) // 2 + 3 = 5
    
    // When
    match.homeScore = 4
    match.awayScore = 1
    let updatedTotalScore = match.totalScore
    
    // Then
    #expect(updatedTotalScore == 5) // 4 + 1 = 5
}

@Test func test_startTime_isUniqueForEachMatch() async throws {
    // Given
    let match1 = Match(homeTeam: "Argentina", awayTeam: "Brazil")
    try await Task.sleep(for: .milliseconds(100))
    let match2 = Match(homeTeam: "Germany", awayTeam: "France")
    
    // Then
    #expect(match1.startTime < match2.startTime)
}

@Test func test_customStringConvertible_descriptionReturnsCorrectString() {
    // Given
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)
    
    // When
    let description = match.description
    
    // Then
    #expect(description == "Argentina 2 - 3 Brazil")
}
