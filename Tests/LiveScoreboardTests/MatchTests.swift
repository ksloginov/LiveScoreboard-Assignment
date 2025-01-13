import Testing
import Foundation
@testable import LiveScoreboard

@Test func test_initialization_setsCorrectProperties() async throws {
    // Given
    let homeTeam = "Argentina"
    let awayTeam = "Brazil"

    
    let startDate = Date(timeIntervalSinceNow: 1000)
    // When
    let match = Match(homeTeam: homeTeam, awayTeam: awayTeam, timeProvider: TimeProvider(date: {
        startDate
    }))

    // Then
    #expect(match.homeTeam == "Argentina")
    #expect(match.awayTeam == "Brazil")
    #expect(match.homeScore == 0)
    #expect(match.awayScore == 0)
    #expect(match.startTime != nil)

    #expect(match.startTime == startDate)
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
    let startDateMatch1 = Date(timeIntervalSinceNow: 1000)
    let startDateMatch2 = Date(timeIntervalSinceNow: 1001)
    let match1 = Match(homeTeam: "Argentina", awayTeam: "Brazil", timeProvider: TimeProvider(date: {
        startDateMatch1
    }))

    let match2 = Match(homeTeam: "Germany", awayTeam: "France", timeProvider: TimeProvider(date: {
        startDateMatch2
    }))

    // Then
    #expect(match1.startTime < match2.startTime)
    #expect(match1.startTime == startDateMatch1)
    #expect(match2.startTime == startDateMatch2)
}

@Test func test_customStringConvertible_descriptionReturnsCorrectString() {
    // Given
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)

    // When
    let description = match.description

    // Then
    #expect(description == "Argentina 2 - 3 Brazil")
}
