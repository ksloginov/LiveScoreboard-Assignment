import LiveScoreboard

var scoreboard = Scoreboard()
try scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "France")
try scoreboard.updateScore(homeTeam: "Argentina", awayTeam: "France", homeScore: 1, awayScore: 0)

try scoreboard.startMatch(homeTeam: "Germany", awayTeam: "Norway")
try scoreboard.updateScore(homeTeam: "Germany", awayTeam: "Norway", homeScore: 3, awayScore: 0)

scoreboard.getSummary().forEach { print($0) }

try scoreboard.finishMatch(homeTeam: "Argentina", awayTeam: "France")

print("---------------------")

scoreboard.getSummary().forEach { print($0) }

try scoreboard.updateScore(homeTeam: "Germany", awayTeam: "Norway", homeScore: 3, awayScore: 3)

print("---------------------")

scoreboard.getSummary().forEach { print($0) }
try scoreboard.updateScore(homeTeam: "Germany", awayTeam: "Norway", homeScore: 0, awayScore: 3)

print("---------------------")

scoreboard.getSummary().forEach { print($0) }
