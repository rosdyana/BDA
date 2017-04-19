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
      sidebarSearchForm(
        textId = "searchText",
        buttonId = "searchButton",
        label = "Team Search..."
      ),
      menuItem("League Table", tabName = "league_table", icon = icon("table")),
      menuItem("Top Scorers", tabName = "top_scorer_ranks", icon = icon("male")),
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
                  title = "Histogram",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  h2("league histogram content")
                ),
                box(
                  title = "Histogram",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  h2("league histogram content")
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
              "<p>Developer : Rosdyana Kusuma</br>email : rosdyana.kusuma@gmail.com</p>"
            )
          )
        )
      ),
      
      tabItem(tabName = "settings",
              h2("Settings content")),
      
      tabItem(
        tabName = "top_scorer_ranks",
        h2("Top Scorers content"),
        plotOutput("topscorerplot")
      )
    )
  )
)
