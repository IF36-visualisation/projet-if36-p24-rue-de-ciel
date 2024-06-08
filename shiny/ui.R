library(shinydashboard)
library(wordcloud2)

dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Les films"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informations", icon = icon("circle-info"),
               menuSubItem("Générales", tabName = "general"),
               menuSubItem("Détails", tabName = "detail")
      ),
      menuItem("La list", tabName = "list", icon = icon("film")),
      menuItem("Les Directeurs", tabName = "directorRank", icon = icon("bar-chart")),
      menuItem("Box-office", tabName = "relationship", icon = icon("dollar-sign")),
      menuItem("Les genres", tabName = "effect", icon = icon("theater-masks")),
      menuItem("Word Clouds", tabName = "wordclouds", icon = icon("cloud"))
    ),
    selectInput("era", "époque : ", c("All", "Silent Era", "The Talkies", "The Change", "Golden Era", "Dawn of Modern", "New Millenia"))
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    tabItems(
      tabItem(tabName = "general",
              h2("Informations sur le dataset"),
              infoBoxOutput("nb_film")
      ),
      tabItem(tabName = "detail",
              h2("Informations détails sur le dataset"),
              box(
                title = "Genre Selection",
                status = "primary",
                solidHeader = TRUE,
                collapsible = FALSE,
                uiOutput("genre")
              ),
              fluidRow(
                box(
                  title = "Détails des films",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  valueBoxOutput("genre_count"),
                  valueBoxOutput("avg_rating_detail"),
                  valueBoxOutput("avg_approval_index"),
                  valueBoxOutput("avg_runtime_detail"),
                  valueBoxOutput("avg_domestic_gross_detail"),
                  valueBoxOutput("avg_worldwide_gross_detail"),
                  width = 12
                )
              )
      ),
      tabItem(tabName = "list",
              h2("Liste des films"),
              dataTableOutput("directorsTable")
      ),
      tabItem(tabName = "directorRank",
              h2("Directeurs"),
              sliderInput("numDirectors",
                          "Top N:",
                          min = 3,
                          max = 20,
                          value = 10),
              fluidRow(
                column(6, h3("Total films Ranking"), plotOutput("directorHist")),
                column(6, h3("Domestic gross Ranking"), plotOutput("directorDomesticHist")),
                column(6, h3("Worldwide gross Ranking"), plotOutput("directorRevenueHist"))
              )
      ),
      tabItem(tabName = "relationship",
              h2("Impact sur le box-office\n"),
              fluidRow(
                box(
                  title = "Distribution des recettes mondiales",
                  status = "primary",
                  plotOutput("plot1")
                ),
                box(
                  title = "Distribution des recettes nationales",
                  status = "primary",
                  plotOutput("plot2")
                ),
                box(
                  title = "Distribution des budgets de production",
                  status = "primary",
                  plotOutput("plot3")
                ),
                box(
                  title = "Relationship between budget & public acceptance",
                  status = "primary",
                  plotOutput("effect_plot3")
                )
              )
      ),
      tabItem(tabName = "effect",
              h2("Comparaison entre les genres\n"),
              fluidRow(
                box(
                  title = "Top 10 Movie Genres",
                  status = "primary",
                  solidHeader = TRUE,
                  plotOutput("effect_plot1")
                ),
                box(
                  title = "Distribution of Domestic Gross Earnings by Genre",
                  status = "primary",
                  solidHeader = TRUE,
                  plotOutput("effect_plot2")
                ),
                box(
                  title = "Average Domestic Gross Earnings by Genre",
                  status = "primary",
                  solidHeader = TRUE,
                  plotOutput("effect_plot")
                )
              )
      ),
      tabItem(tabName = "wordclouds",
              h2("Word Clouds"),
              fluidRow(
                box(
                  title = "Word Clouds",
                  status = "primary",
                  solidHeader = TRUE,
                  wordcloud2Output("genreWordcloud", width = "100%", height = "600px")  # 设置宽度为100%，高度为600px
                )
              )
      )
    )
  )
)
