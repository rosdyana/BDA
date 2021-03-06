library(plotly)
library(jsonlite)
library(dplyr)
library(leaflet)
library(eeptools)

# league table data
table_url = ""
mapfile = ""

leagueInput <- function(x) {
  if (x == "Premier League") {
    table_url = "leaguetable/premier_league.json"
  }
  if (x == "Championship") {
    table_url = "leaguetable/england_Championship.json"
  }
  if (x == "League One") {
    table_url = "leaguetable/england_leagueone.json"
  }
  if (x == "Serie A") {
    table_url = "leaguetable/ita_seriea.json"
  }
  if (x == "Serie B") {
    table_url = "leaguetable/ita_serieb.json"
  }
  if (x == "Primera Division") {
    table_url = "leaguetable/spain_primera_division.json"
  }
  if (x == "Liga Adelante") {
    table_url = "leaguetable/spain_adelante.json"
  }
  if (x == "1st Bundesliga") {
    table_url = "leaguetable/bundesliga_1.json"
  }
  if (x == "2nd Bundesliga") {
    table_url = "leaguetable/bundesliga_2.json"
  }
  if (x == "Ligue 1") {
    table_url = "leaguetable/france_ligue_1.json"
  }
  if (x == "Ligue 2") {
    table_url = "leaguetable/france_ligue_2.json"
  }
  return(table_url)
}

# top scorers data

# team profile data

server <- function(input, output) {
  output$table <- DT::renderDataTable(DT::datatable({
    xx = leagueInput(input$league)
    table_data_ori = fromJSON(xx)
    
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
    data <- table_df
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
  })
  output$topscorertable <- DT::renderDataTable(DT::datatable({
    # xx = leagueInput(input$league)
    table_data_ori = fromJSON("topscorers/ita_topscorers.json")
    
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
  }))
  
  output$topscorerplot <- renderPlotly({
    table_data_ori = fromJSON("topscorers/ita_topscorers.json")
    df = data.frame(
      Name = table_data_ori$data$topscorers$fullname,
      Goals = table_data_ori$data$topscorers$goals
    )
    df[, c("Name", "Goals")]
    newdf <- df %>% select(Name, Goals) %>% filter(Goals == input$n)
    p <-
      plot_ly(
        newdf,
        labels = ~ Name,
        values = ~ Goals,
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
  })
  
  observeEvent(input$about, {
    showModal(modalDialog(
      title = span(tagList(icon("info-circle"), "About")),
      tags$div(
        HTML(
          "<img src='https://avatars1.githubusercontent.com/u/4516635?v=3&s=460' width=150><br/><br/>",
          "<p>Developer : Rosdyana Kusuma</br>Email : <a href=mailto:rosdyana.kusuma@gmail.com>rosdyana.kusuma@gmail.com</a></br>linkedin : <a href='https://www.linkedin.com/in/rosdyanakusuma/' target=blank>Open me</a></p>",
          "<iframe src='https://www.facebook.com/plugins/share_button.php?href=https%3A%2F%2Frosdyana.shinyapps.io%2FSoccerLeague%2F&layout=box_count&size=small&mobile_iframe=true&width=61&height=40&appId' width='61' height='40' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true'></iframe>"
        )
      ),
      easyClose = TRUE
    ))
  })
  leagueMapInput <- function(x) {
    if (x == "Serie A") {
      mapfile = "leaguemaps/seriea_map.csv"
    }
    if (x == "Serie B") {
      mapfile = "leaguemaps/serieb_map.csv"
    }
    if (x == "Premier League") {
      mapfile = "leaguemaps/england_premiership_map.csv"
    }
    if (x == "Championship") {
      mapfile = "leaguemaps/championship_map.csv"
    }
    return(mapfile)
  }
  output$leaguemapoutput <- renderLeaflet({
    xx = leagueMapInput(input$leaguemapselect)
    mapdata <- read.csv(xx)
    UserIcon <- makeIcon(iconUrl = mapdata$logo,
                         iconWidth = 20)
    content <- paste(
      "<b>",
      mapdata$team,
      "</b><br/>",
      "Stadium name :",
      mapdata$stadium_name,
      "<br/>",
      "City :",
      mapdata$city,
      "<br/>",
      "Capacity :",
      mapdata$capacity
    )
    m = leaflet()
    m = addTiles(m)
    m = addMarkers(
      m,
      lng = mapdata$lng,
      lat = mapdata$lat,
      popup = content,
      icon = UserIcon
    )
    m
    
  })
  
  
  output$teamProfileContent <- renderUI({
    dt1 <- data.frame(fromJSON("teams/juve_profile.json"))
    dt2 <- data.frame(fromJSON("teams/barca_profile.json"))
    profiles <- merge(dt1, dt2, all = T)
    if (input$teamProfile == "Juventus") {
      profiles <- profiles[1, ]
    }
    if (input$teamProfile == "Barcelona") {
      profiles <- profiles[2, ]
    }
    str0 <-
      paste("<img src='",
            profiles$crestUrl,
            "' width=50'<br/><br/>")
    str1 <- paste("Team : ", profiles$name, "<br/>")
    str2 <-
      paste("Market Value : ", profiles$squadMarketValue, "<br/>")
    HTML(paste(str0, str1, str2))
  })
  
  
  output$playertable <- DT::renderDataTable(DT::datatable({
    if (input$teamProfile == "Juventus") {
      clubPlayers <- fromJSON("teams/juve_players.json")
    }
    if (input$teamProfile == "Barcelona") {
      clubPlayers <- fromJSON("teams/barca_players.json")
    }
    
    table_data = clubPlayers$players
    table_df = data.frame(
      Name = table_data$name,
      Nationality = table_data$nationality,
      Age = floor(age_calc(
        dob = as.Date(table_data$dateOfBirth),
        enddate = Sys.Date(),
        units = "years"
      )),
      Position = table_data$position,
      Number = table_data$jerseyNumber
    )
    if (input$playerpositionselect != "ALL") {
      table_df <-
        table_df %>% select(Name, Nationality, Age, Position, Number) %>% filter(Position == input$playerpositionselect)
    }
    data <- table_df
  }))
  
  output$teamfixtures <- DT::renderDataTable(DT::datatable({
    if (input$teamProfile == "Juventus") {
      clubFixtures <-  fromJSON("teams/juve_fixtures.json")
    }
    if (input$teamProfile == "Barcelona") {
      clubFixtures <- fromJSON("teams/barca_fixtures.json")
    }
    table_data = clubFixtures$fixtures
    table_df = data.frame(
      Date = substring(table_data$date, 1, 10),
      Home = table_data$homeTeamName,
      Away = table_data$awayTeamName,
      Result = paste(
        table_data$result$goalsHomeTeam,
        "-",
        table_data$result$goalsAwayTeam
      )
    )
    
    data <- table_df
  }))
}