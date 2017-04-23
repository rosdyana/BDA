library(shiny)
library(shinydashboard)
library(plotly)
library(leaflet)

options(shiny.sanitize.errors = TRUE)
ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = span(tagList(
    icon("futbol-o"), "Soccer League"
  )),
  titleWidth = 250),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Leagues",
        tabName = "",
        icon = icon("soccer-ball-o"),
        menuSubItem('Leagues Table',
                    tabName = 'league_table',
                    icon = icon('table')),
        menuSubItem('Leagues Map',
                    tabName = 'leagueMap',
                    icon = icon('map'))
      ),
      menuItem("Top Scorers", tabName = "top_scorer_ranks", icon = icon("male")),
      menuItem("Team Profile", tabName = "team_profile", icon = icon("shield")),
      actionButton("about", "About", icon = icon("info-circle")),
      actionButton(
        "github",
        "Github",
        icon = icon("github"),
        onclick = "window.open('https://github.com/rosdyana/BDA/tree/master/HW2', '_blank')"
      )
    )
  ),
  dashboardBody(
    tags$head(tags$style(
      HTML(
        '
        .main-header .logo {
        font-family: "Open Sans", sans-serif;
        font-weight: bold;
        font-size: 24px;
        }
        '
      )
      )),
    tabItems(
      # First tab content
      tabItem(tabName = "league_table",
              fluidPage(
                box(
                  title =   tagList(shiny::icon("table") , "League Table"),
                  width = NULL,
                  status = "primary",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  selectInput(
                    "league",
                    "Select league",
                    list(
                      "England" = c("Premier League", "Championship", "League One"),
                      "Italy" = c("Serie A", "Serie B"),
                      "Spain" = c("Primera Division", "Liga Adelante"),
                      "Germany" = c("1st Bundesliga", "2nd Bundesliga"),
                      "France" = c("Ligue 1", "Ligue 2")
                    )
                  ),
                  
                  DT::dataTableOutput("table")
                ),
                box(
                  title = "Home Statistic",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  selectInput("homechartType",
                              "Select Type",
                              list("Pie", "Bar", "Line")),
                  plotlyOutput("homestatsplot")
                ),
                box(
                  title = "Away Statistic",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  selectInput("awaychartType",
                              "Select Type",
                              list("Pie", "Bar", "Line")),
                  plotlyOutput("awaystatsplot")
                )
              )),
      tabItem(tabName = "leagueMap",
              fluidPage(
                box(
                  title = tagList(shiny::icon("map") , "League Map"),
                  width = NULL,
                  status = "primary",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  leafletOutput("leaguemapoutput"),
                  selectInput(
                    "leaguemapselect",
                    "Select league",
                    list(
                      "England" = c("Premier League", "Championship"),
                      "Italy" = c("Serie A", "Serie B")
                    )
                  )
                )
              )),
      tabItem(
        tabName = "team_profile",
        selectizeInput(
          'teamProfile',
          'Select Team',
          choices = c("Juventus", "Barcelona"),
          multiple = FALSE
        )
      ),
      tabItem(tabName = "top_scorer_ranks",
              fluidPage(
                box(
                  title = tagList(shiny::icon("male") , "Top Scorers Table"),
                  width = NULL,
                  status = "primary",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  selectInput("league",
                              "Select league",
                              list("Italy" = c("Serie A", "Serie B"))),
                  DT::dataTableOutput("topscorertable"),
                  plotlyOutput("topscorerplot"),
                  sliderInput(
                    "n",
                    "Number of goals:",
                    min = 1,
                    max = 30,
                    value = 5,
                    step = 1
                  )
                )
              ))
    )
      )
    )