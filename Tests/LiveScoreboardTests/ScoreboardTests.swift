import Testing
@testable import LiveScoreboard

@Test func test_startMatch_startsNewMatch() throws {
    // Given
    var scoreboard = Scoreboard()

    // When
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // Then
    let matches = scoreboard.getSummary()
    #expect(matches.count == 1)
    #expect(matches[0].homeTeam == "Argentina")
    #expect(matches[0].awayTeam == "Brazil")
    #expect(matches[0].homeScore == 0)
    #expect(matches[0].awayScore == 0)
}

@Test func test_startMatch_throwsErrorForDuplicateTeam() throws {
    // Given
    var scoreboard = Scoreboard()
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // Then
    #expect(throws: ScoreboardError.teamAlreadyInMatch, performing: {
        try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Germany")
    })
}

@Test func test_finishMatch_removesMatch() throws {
    // Given
    var scoreboard = Scoreboard()
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // When
    try scoreboard.finishMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // Then
    let matches = scoreboard.getSummary()
    #expect(matches.count == 0)
}

@Test func test_finishMatch_throwsErrorForNonexistentMatch() {
    // Given
    var scoreboard = Scoreboard()

    // Then
    #expect(throws: ScoreboardError.matchNotFound, performing: {
        try scoreboard.finishMatch(homeTeam: "Argentina", awayTeam: "Brazil")
    })
}

@Test func test_updateScore_throwErrorForFlippedHomeAwayTeams() throws {
    // Given
    var scoreboard = Scoreboard()

    // When
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // Then
    #expect(throws: ScoreboardError.matchNotFound, performing: {
        try scoreboard.updateScore(homeTeam: "Brazil", awayTeam: "Argentina", homeScore: 0, awayScore: 1)
    })
}

@Test func test_updateScore_updatesMatchScore() throws {
    // Given
    var scoreboard = Scoreboard()
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // When
    try scoreboard.updateScore(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 3, awayScore: 2)

    // Then
    let matches = scoreboard.getSummary()
    #expect(matches[0].homeScore == 3)
    #expect(matches[0].awayScore == 2)
}

@Test func test_updateScore_throwsErrorForInvalidScore() throws {
    // Given
    var scoreboard = Scoreboard()
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")

    // Then
    #expect(throws: ScoreboardError.invalidScore, performing: {
        try scoreboard.updateScore(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: -1, awayScore: 2)
    })
}

@Test func test_getSummary_returnsMatchesInOrderOfTotalScore() throws {
    // Given
    var scoreboard = Scoreboard()
    try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "Brazil")
    try scoreboard.startMatch(homeTeam: "Germany", awayTeam: "France")
    try scoreboard.updateScore(homeTeam: "Argentina", awayTeam: "Brazil", homeScore: 2, awayScore: 3)
    try scoreboard.updateScore(homeTeam: "Germany", awayTeam: "France", homeScore: 1, awayScore: 1)

    // When
    var summary = scoreboard.getSummary()

    // Then
    #expect(summary[0].homeTeam == "Argentina")
    #expect(summary[0].awayTeam == "Brazil")
    #expect(summary[1].homeTeam == "Germany")
    #expect(summary[1].awayTeam == "France")

    // Given
    try scoreboard.startMatch(homeTeam: "Sweden", awayTeam: "Danmark")
    try scoreboard.updateScore(homeTeam: "Sweden", awayTeam: "Danmark", homeScore: 5, awayScore: 0)

    // When
    summary = scoreboard.getSummary()
    #expect(summary[0].homeTeam == "Sweden")
    #expect(summary[0].awayTeam == "Danmark")
    #expect(summary[1].homeTeam == "Argentina")
    #expect(summary[1].awayTeam == "Brazil")
}

@Test func test_normalizeTeamName_normalizesCorrectly() {
    // Given
    let scoreboard = Scoreboard()

    // When
    let normalizedName = scoreboard.normalizeTeamName("  ArGenTIna  ")

    // Then
    #expect(normalizedName == "Argentina")
}

@Test func test_startMatch_throwsErrorForInvalidTeamName() {
    // Given
    var scoreboard = Scoreboard()

    // Then
    #expect(throws: ScoreboardError.invalidTeamName, performing: {
        try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "argentina")
    })

    #expect(throws: ScoreboardError.invalidTeamName, performing: {
        try scoreboard.startMatch(homeTeam: "        ", awayTeam: "argentina")
    })
}
