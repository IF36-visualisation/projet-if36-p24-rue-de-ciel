library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(plotly)
library(shinyWidgets)
library(DT)
library(colorspace)


film_all <- read_delim("../data/different_era_film_data/movies_dataset.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)
film_Silent_Era <- read_delim("../data/different_era_film_data/Silent_Era.csv", 
                                delim = ",", escape_double = FALSE, na = "-", 
                                trim_ws = TRUE, show_col_types = FALSE)
film_The_Talkies <- read_delim("../data/different_era_film_data/The_Talkies.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)
film_The_Change <- read_delim("../data/different_era_film_data/The_Change.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)
film_Golden_Era <- read_delim("../data/different_era_film_data/Golden_Era.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)
film_Dawn_of_Modern <- read_delim("../data/different_era_film_data/Dawn_of_Modern.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)
film_New_Millenia <- read_delim("../data/different_era_film_data/New_Millenia.csv", 
                           delim = ",", escape_double = FALSE, na = "-", 
                           trim_ws = TRUE, show_col_types = FALSE)


shinyServer(function(input, output) {
  
  era <- reactive({
    input$era
  })
  
  film_data <- reactive({
    if(era() == "Silent Era") {
      film_Silent_Era
    } else if(era() == "The Talkies") {
      film_The_Talkies
    }else if(era() == "The Change") {
      film_The_Change
    }else if(era() == "Golden Era") {
      film_Golden_Era
    }else if(era() == "Dawn of Modern") {
      film_Dawn_of_Modern
    }else if(era() == "New Millenia") {
      film_New_Millenia
    } else {
      film_all
    }
  })
  
  genres <- reactive ({
    unique(unlist(strsplit(paste(film_data()$genres, collapse = ","), ",")))
  })
  
  filtered_data <- reactive ({
    film_data() %>%
      filter(sapply(genres, function(x) any(grepl(input$genre, x))))
  })
  
  output$genre <- renderUI({
    selectInput("genre", "Choisir une genre", choices = genres())
  })
  
  output$nb_film <- renderInfoBox({
    total_rows <- nrow(film_data())
    infoBox("Total Films", total_rows, icon = icon("film"), color = "blue")
  })
  
  output$genre_count <- renderValueBox({
    filtered_df <- film_data() %>%
      filter(grepl(input$genre, genres))
    genre_count <- nrow(filtered_df)
    valueBox(genre_count, "Total Nombre", icon = icon("list"), color = "yellow")
  })
  
  output$avg_rating_detail <- renderValueBox({
    avg_rating <- mean(filtered_data()$movie_averageRating, na.rm = TRUE)
    valueBox(round(avg_rating, 2), "Avg Rating", icon = icon("star"), color = "green")
  })
  
  output$avg_approval_index <- renderValueBox({
    avg_runtime <- mean(filtered_data()$approval_Index, na.rm = TRUE)
    valueBox(round(avg_runtime, 2), "Avg Approval Index", icon = icon("thumbs-up"), color ="aqua")
  })
  
  output$avg_runtime_detail <- renderValueBox({
    avg_runtime <- mean(filtered_data()$runtime_minutes, na.rm = TRUE)
    valueBox(paste0(round(avg_runtime, 2)," Min"), "Avg Runtime", icon = icon("clock"), color = "yellow")
  })
  
  output$avg_domestic_gross_detail <- renderValueBox({
    avg_domestic_gross <- mean(filtered_data()$`Domestic gross $`, na.rm = TRUE)
    valueBox(paste0(round(avg_domestic_gross / 1e6, 2)," M$"), "Avg Domestic Gross", icon = icon("dollar-sign"), color = "purple")
  })
  
  output$avg_worldwide_gross_detail <- renderValueBox({
    avg_worldwide_gross <- mean(filtered_data()$`Worldwide gross $`, na.rm = TRUE)
    valueBox(paste0(round(avg_worldwide_gross / 1e6, 2)," M$"), "Avg Worldwide Gross", icon = icon("globe"), color = "red")
  })
  
  output$directorsTable <- renderDataTable({
    #data <- film_data()
    #sorted_data <- directors_data[order(-directors_data$`Worldwide gross $`), ]
    datatable(film_data(), options = list(
      pageLength = 10,  # 默认显示10行数据
      scrollX = TRUE,   # 启用水平滚动
      autoWidth = TRUE,  # 自动调整列宽
      order = list(list(0, 'asc'))  # 默认按照第一列升序排序
    ))
  })
  
  # 计算每位导演的电影总数量
  director_stats <- reactive({
    film_data() %>%
      filter(!is.na(director_name)) %>%
      group_by(director_name) %>%
      summarise(MoviesCount = n(),
                TotalGlobalRevenue = sum(`Worldwide gross $`, na.rm = TRUE) / 1e6,  # 转换为百万美元
                TotalDomesticRevenue = sum(`Domestic gross $`, na.rm = TRUE) / 1e6  # 转换为百万美元
      ) %>%
      arrange(desc(MoviesCount))
  })
  
  # 渲染电影数量的直方图
  output$directorHist <- renderPlot({
    top_directors <- director_stats() %>%
      head(input$numDirectors)
    ggplot(top_directors, aes(x = reorder(director_name, -MoviesCount), y = MoviesCount, fill = director_name)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = MoviesCount), vjust = -0.3, color = "black", size = 3.5) +
      labs(title = "Top Directors by Number of Movies", x = "Director", y = "Number of Movies") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$directorDomesticHist <- renderPlot({
    top_revenue_directors <- director_stats() %>%
      arrange(desc(TotalDomesticRevenue)) %>%
      head(input$numDirectors)
    ggplot(top_revenue_directors, aes(x = reorder(director_name, -TotalDomesticRevenue), y = TotalDomesticRevenue, fill = director_name)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = scales::comma(round(TotalGlobalRevenue))), vjust = -0.3, color = "black", size = 3.5) +
      labs(title = "Top Directors by Domestic Gross (Millions $)", x = "Director", y = "Domestic Gross (Millions $)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # 渲染全球票房的直方图
  output$directorRevenueHist <- renderPlot({
    top_revenue_directors <- director_stats() %>%
      arrange(desc(TotalGlobalRevenue)) %>%
      head(input$numDirectors)
    ggplot(top_revenue_directors, aes(x = reorder(director_name, -TotalGlobalRevenue), y = TotalGlobalRevenue, fill = director_name)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = scales::comma(round(TotalGlobalRevenue))), vjust = -0.3, color = "black", size = 3.5) +
      labs(title = "Top Directors by Global Gross (Millions $)", x = "Director", y = "Global Gross(Millions $)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$plot1 <- renderPlot({
    movie_data <- film_data()
    ggplot(movie_data, aes(x = "", y = `Worldwide gross $`)) +
      geom_boxplot(fill = "green") +
      labs(title = "Worldwide gross distribution") +
      theme(axis.title.x = element_blank())
  })
  
  output$plot2 <- renderPlot({
    movie_data <- film_data()
    ggplot(movie_data, aes(x = "", y = `Domestic gross $`)) +
      geom_boxplot(fill = "blue") +
      labs(title = "Domestic gross distribution") +
      theme(axis.title.x = element_blank())
  })
  
  output$plot3 <- renderPlot({
    movie_data <- film_data()
    ggplot(movie_data, aes(x = "", y = `Production budget $`)) +
      geom_boxplot(fill = "red") +
      labs(title = "Production budget distribution") +
      theme(axis.title.x = element_blank())
  })
  
  # 新增的图表渲染代码
  output$effect_plot1 <- renderPlot({
    genre_counts_processed <- film_data() %>%
      separate_rows(genres, sep = ",") %>%
      group_by(genres) %>%
      summarise(movie_count = n()) %>%
      arrange(desc(movie_count)) %>%
      head(10)
    
    ggplot(genre_counts_processed, aes(x = reorder(genres, -movie_count), y = movie_count, fill = genres)) +
      geom_bar(stat = "identity") +
      labs(title = "Top 10 Movie Genres", x = "Genres", y = "Number of Movies") +
      theme_minimal() +
      scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#ffd92f", "#e5c494", "#b3b3b3", "#1f78b4", "#33a02c")) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$effect_plot2 <- renderPlot({
    plot_data <- film_data() %>% select(genres, `Domestic gross $`)
    plot_data <- plot_data %>% separate_rows(genres, sep = ",")
    colnames(plot_data) <- c("Genre", "Domestic_gross")
    plot_data$Domestic_gross <- as.numeric(plot_data$Domestic_gross)
    plot_data <- plot_data %>% drop_na(Domestic_gross)
    
    ggplot(plot_data, aes(x = Genre, y = Domestic_gross, fill = Genre)) +
      geom_boxplot() +
      coord_flip() +
      labs(title = "Distribution of Domestic Gross Earnings by Genre",
           x = "Genre",
           y = "Domestic Gross Earnings") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  output$effect_plot3 <- renderPlot({
    data <- film_data() %>%
      separate_rows(genres, sep = ",")
    
    unique_genres <- unique(data$genres)
    palette <- rainbow_hcl(length(unique_genres), start = 0, end = 360)
    color_mapping <- setNames(palette, unique_genres)
    
    ggplot(data, aes(x = approval_Index, y = `Production budget $`, color = genres, size = movie_numerOfVotes)) +
      geom_point(alpha = 0.6, shape = 16) +
      scale_color_manual(values = color_mapping) +
      scale_x_continuous(breaks = 0:10, labels = 0:10) +
      scale_y_continuous(labels = scales::dollar) +
      labs(
        title = "Relationship between budget & public acceptance",
        x = "approval_Index",
        y = "Production budget $",
        color = "Main Genre",
        size = "Number of Votes"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5),
        legend.position = "right"
      )
  })
  output$effect_plot <- renderPlot({
    genre_gross_processed <- film_data() %>%
      separate_rows(genres, sep = ",") %>%
      group_by(genres) %>%
      summarise(Average_Domestic_Gross = mean(`Domestic gross $`, na.rm = TRUE))
    
    ggplot(genre_gross_processed, aes(x = reorder(genres, Average_Domestic_Gross), y = Average_Domestic_Gross, fill = genres)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Average Domestic Gross Earnings by Genre",
           x = "Genre",
           y = "Average Domestic Gross Earnings") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  # 渲染种类词云图
  output$genreWordcloud <- renderWordcloud2({
    genre_data <- film_data() %>%
      separate_rows(genres, sep = ",") %>%
      count(genres) %>%
      arrange(desc(n))
    wordcloud2(data = genre_data, size = 0.7, color = 'random-light', backgroundColor = "grey")
  })
  
})