
library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = span(tagList(icon("futbol-o"), "Soccer League")),
                  titleWidth = 250),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("League Table",tabName = "league_table", icon = icon("table")),
      menuItem("Settings", tabName = "settings", icon = icon("cog")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Open Sans", sans-serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    tabItems(
      # First tab content
      tabItem(tabName = "home",
              h2("Home tab content")
      ),
      
      # Second tab content
      tabItem(tabName = "league_table",
              h2("League tab content")
      ),
      
      # third tab content
      tabItem(tabName = "about",
              h2("League About tab content")
      ),
      tabItem(tabName = "settings",
              h2("Settings content")
      )
    )
  )
)
