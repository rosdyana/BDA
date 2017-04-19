library(shiny)
library(shinydashboard)
library(plotly)
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
                    icon = icon('map')),
        menuSubItem(
          'Leagues Profile',
          tabName = 'leagueProfile',
          icon = icon('address-book')
        )
      ),
      menuItem("Top Scorers", tabName = "top_scorer_ranks", icon = icon("male")),
      menuItem("Team Profile", tabName = "team_profile", icon = icon("shield")),
      menuItem("Settings", tabName = "settings", icon = icon("cog")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
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
                  title = "League Table",
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
                      "Spain" = c("Primera Division", "Liga Adelante")
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
      
      tabItem(
        tabName = "about",
        box(
          title = "About",
          status = "info",
          width = NULL,
          solidHeader = TRUE,
          collapsible = TRUE,
          tags$div(
            HTML(
              "<p>Developer : Rosdyana Kusuma</br>Email : <a href=mailto:rosdyana.kusuma@gmail.com>rosdyana.kusuma@gmail.com</a></p>",
              "<iframe src='https://www.facebook.com/plugins/share_button.php?href=https%3A%2F%2Frosdyana.shinyapps.io%2FSoccerLeague%2F&layout=box_count&size=small&mobile_iframe=true&width=61&height=40&appId' width='61' height='40' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true'></iframe>"
            )
          )
        )
      ),
      
      tabItem(tabName = "settings",
              h2("Settings content")),
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
                  title = "Top Scorers Table",
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
                      "Spain" = c("Primera Division", "Liga Adelante")
                    )
                  ),
                  DT::dataTableOutput("topscorertable")
                )
              ))
    )
  )
)
