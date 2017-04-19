library(plotly)
library(jsonlite)
library(dplyr)

server <- function(input, output) {
  # serie-A Italy topscorers
  serie_a_ita_topscorers = "http://soccer.sportsopendata.net/v1/leagues/serie-a/seasons/16-17/topscorers"
  serie_a_ita_topscorers_data = fromJSON(serie_a_ita_topscorers)
  serie_a_ita_topscorers_df = tbl_df(
    data.frame(
      serie_a_ita_topscorers_data$data$topscorers,
      stringsAsFactors = FALSE
    )
  )
  output$table <- DT::renderDataTable(DT::datatable({
    table_url = ""
    fbd = FALSE
    if (input$league == "Premier League") {
      table_url = "http://api.football-data.org/v1/soccerseasons/426/leagueTable"
      fbd = TRUE
    }
    if (input$league == "Championship") {
      table_url = "http://api.football-data.org/v1/soccerseasons/427/leagueTable"
      fbd = TRUE
    }
    if (input$league == "League One") {
      table_url = "http://api.football-data.org/v1/soccerseasons/428/leagueTable"
      fbd = TRUE
    }
    if (input$league == "Serie A") {
      table_url = "http://api.football-data.org/v1/soccerseasons/438/leagueTable"
      fbd = TRUE
    }
    if (input$league == "Serie B") {
      table_url = "http://soccer.sportsopendata.net/v1/leagues/serie-b/seasons/16-17/standings"
      fbd = FALSE
    }
    
    table_data_ori = fromJSON(table_url)
    
    if (fbd) {
      table_data = table_data_ori$standing
      table_df = data.frame(
        Team = table_data$teamName,
        P = table_data$playedGames,
        W = table_data$wins,
        D = table_data$draws,
        L = table_data$losses,
        F = table_data$goals,
        A = table_data$goalsAgainst,
        G = table_data$goalDifference,
        Pts = table_data$points
      )
    } else {
      table_data = table_data_ori$data$standings
      table_df = data.frame(
        Team = table_data$team,
        P = table_data$overall$matches_played,
        W = table_data$overall$wins,
        D = table_data$overall$draws,
        L = table_data$overall$losts,
        F = table_data$overall$scores,
        A = table_data$overall$conceded,
        G = table_data$overall$goal_difference,
        Pts = table_data$overall$points
      )
    }
    
    
    data <- table_df
    data
  }))
}
