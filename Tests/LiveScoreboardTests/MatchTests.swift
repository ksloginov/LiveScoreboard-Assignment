import Testing
import Foundation
@testable import LiveScoreboard

@Test func testMatchInitialization() async throws {
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil")
    
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

@Test func testIsTeamPlayingInMatch() {
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil")
    
    #expect(match.isTeamPlayingInMatch("Argentina"))
    #expect(match.isTeamPlayingInMatch("Brazil"))
    #expect(!match.isTeamPlayingInMatch("Germany"))
}

@Test func testTotalScoreCalculation() {
    var match = Match(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)
    
    #expect(match.totalScore == 5) // 2 + 3 = 5
    
    match.homeScore = 4
    match.awayScore = 1
    
    #expect(match.totalScore == 5) // 4 + 1 = 5
}

@Test func testStartTimeInitialization() async throws {
    let match1 = Match(homeTeam: "Argentina", awayTeam: "Brazil")
    try await Task.sleep(for: .milliseconds(100))
    let match2 = Match(homeTeam: "Germany", awayTeam: "France")
    
    #expect(match1.startTime < match2.startTime)
}

@Test func testCustomStringConvertibleConformance() {
    let match = Match(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)
    #expect(match.description == "Argentina 2 - 3 Brazil")
}
