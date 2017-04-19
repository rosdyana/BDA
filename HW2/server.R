library(plotly)
library(jsonlite)
library(dplyr)
table_url = ""
fbd = TRUE
leagueInput <- function(x) {
  if (x == "Premier League") {
    table_url = "premier_league.json"
  }
  if (x == "Championship") {
    table_url = "england_Championship.json"
  }
  if (x == "League One") {
    table_url = "england_leagueone.json"
  }
  if (x == "Serie A") {
    table_url = "ita_seriea.json"
  }
  if (x == "Serie B") {
    table_url = "ita_serieb.json"
  }
  return(table_url)
}
server <- function(input, output) {
  output$table <- DT::renderDataTable(DT::datatable({
    xx = leagueInput(input$league)
    table_data_ori = fromJSON(xx)
    if (xx == "ita_serieb.json")
      fbd = FALSE
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
        Pts = table_data$overall$points,
        fbd = TRUE
      )
    }
    
    
    data <- table_df
    data
  }))
  
  output$homestatsplot <- renderPlotly({
    xx = leagueInput(input$league)
    table_data_ori = fromJSON(xx)
    table_data = table_data_ori$standing
    df = data.frame(Team = table_data$team,
                    W = table_data$home$wins)
    if (input$homechartType == "Bar") {
      p <- plot_ly(df, y = ~ W * 3, x = ~ Team)
    } else if (input$homechartType == "Line") {
      p <-
        plot_ly(
          df,
          y = ~ W * 3,
          x = ~ Team,
          type = 'scatter',
          mode = 'lines'
        )
    } else{
      p <-
        plot_ly(
          df,
          labels = ~ table_data$team,
          values = ~ table_data$home$wins * 3,
          type = 'pie',
          showlegend = FALSE
        ) %>%
        layout(
          title = '',
          xaxis = list(
            showgrid = FALSE,
            zeroline = FALSE,
            showticklabels = FALSE
          ),
          yaxis = list(
            showgrid = FALSE,
            zeroline = FALSE,
            showticklabels = FALSE
          )
        )
    }
    p
  })
  
  output$awaystatsplot <- renderPlotly({
    xx = leagueInput(input$league)
    table_data_ori = fromJSON(xx)
    table_data = table_data_ori$standing
    df = data.frame(Team = table_data$team,
                    W = table_data$away$wins)
    if (input$awaychartType == "Bar") {
      p <- plot_ly(df, y = ~ W * 3, x = ~ Team)
    }
    else if (input$awaychartType == "Line") {
      p <-
        plot_ly(
          df,
          y = ~ W * 3,
          x = ~ Team,
          type = 'scatter',
          mode = 'lines'
        )
    } else {
      p <-
        plot_ly(
          df,
          labels = ~ table_data$team,
          values = ~ table_data$away$wins * 3,
          type = 'pie',
          showlegend = FALSE
        ) %>%
        layout(
          title = '',
          xaxis = list(
            showgrid = FALSE,
            zeroline = FALSE,
            showticklabels = FALSE
          ),
          yaxis = list(
            showgrid = FALSE,
            zeroline = FALSE,
            showticklabels = FALSE
          )
        )
    }
    
    p
  })
  output$topscorertable <- DT::renderDataTable(DT::datatable({
    # xx = leagueInput(input$league)
    table_data_ori = fromJSON("ita_topscorers.json")
    
    table_data = table_data_ori$data$topscorers
    table_df = data.frame(
      Name = table_data$fullname,
      Team = table_data$team,
      Nationality = table_data$nationality,
      Matches = table_data$matches,
      Penalties = table_data$penalties,
      Goals = table_data$goals
      
    )
    
    
    data <- table_df
    data
  }))
}
