library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "purple",
    dashboardHeader(title = "Word Prediction"),
    ## Side bar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Model", tabName = "model", icon = icon("keyboard")),
            menuItem("Information", tabName = "info", icon = icon("info-circle")),
            br(),
            tags$p("Version 0.0.1", align = "center")
        )
    ),
    ## Body content
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "model", 
                    fluidRow(
                        column(width = 12, h3(icon("keyboard"), HTML("&nbsp;"), tags$b("Word Prediction Model"))),
                        box(title = "Input for Next Word Prediction", width = 12,
                            fluidRow(column(width = 10, textInput("InputId", label = NULL)),
                                     column(width = 2, submitButton("Submit", width = "100%"), align = "center")),
                            fluidRow(column(width = 12, tags$b("Instruction: Please FILL UP the sentence, phrase or prior words that want to predict the next word and then PRESS Submit Button")))
                        ),
                        box(title = "Result of predicted 10-Next Words based on Model", width = 12,
                            fluidRow(box(title = "Quadgram", width = 3, solidHeader = TRUE, status = "primary", textOutput("Quadgram"), height = 120, align = "center"),
                                     box(title = "Trigram", width = 3, solidHeader = TRUE, status = "success", textOutput("Trigram"), height = 120, align = "center"),
                                     box(title = "Bigram", width = 3, solidHeader = TRUE, status = "warning", textOutput("Bigram"), height = 120, align = "center"),
                                     box(title = "Unigram", width = 3, solidHeader = TRUE, status = "danger", textOutput("Unigram"), height = 120, align = "center")),
                            fluidRow(valueBoxOutput("NumQuad", 3), valueBoxOutput("NumTri", 3), valueBoxOutput("NumBi", 3), valueBoxOutput("NumUni", 3)),
                            fluidRow(column(width = 12, tags$h5(tags$b("Note: "))),
                                     column(width = 12, tags$h5("1. Words from higher order n-gram is most likely to be more accurated, while lower order n-gram model are tended to be less accurated.")),
                                     column(width = 12, tags$h5("2. Words in each n-gram in the above table are ranked based on the probability of the database, which are gathered from blogs, news, and twitters.")))
                        )
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "info",
                    fluidRow(
                        column(width = 12, h3(icon("info-circle"), HTML("&nbsp;"), tags$b("Information"))),
                        box(title = "Synopsis", width = 12, status = "success",
                            tags$p("This application is a final assignment of \"Data Science Specialization: Capstone Project\", which conducted by John Hopkins University
                            in cooperating with SwiftKey. The objective of the application is to developed the data product in a proper manner to predict the next word based on
                            given dataset and n-gram algorithms for language modeling. During the developing the data products, it is found that the work processes can be separated
                            into 8 different tasks that cover the range of activities encountered by a practicing data scientist. The tasks are consist of:"),
                            tags$ol(
                                tags$li("Understanding the problem"),
                                tags$li("Data acquisition and cleaning"),
                                tags$li("Exploratory analysis"),
                                tags$li("Statistical modeling"),
                                tags$li("Predictive modeling"),
                                tags$li("Creative exploration"),
                                tags$li("Creating a data product (Shiny application)"),
                                tags$li("Creating a short slide deck (< 5 pages) for pitching your product"),
                                tags$a(href="https://rpubs.com/thawatchai_p/608459", "Application for Word Prediction"),
                                ),  
                            tags$p("After the different predictive (n-gram) model is built, it is evaluated the performance by calculating the model perplexity.
                                   The results indicated that:"),
                            tags$ol(
                                tags$li("Unigram model perplexity = 1161536"),
                                tags$li("Bigram model perplexity = 298"),
                                tags$li("Trigram model perplexity = 13"),
                                tags$li("Quadgram model perplexity = 4")
                                ),
                            tags$p("Although it is apparently indicated that higher order n-gram model will get the better model performance; however, it is also cause a lot of time
                            consumed process, and that may affect to the overall performance of the application. Therefore, it may be sometimes need to optimize the model accuracy with time consume.")
                        ),
                        box(title = "Reference", width = 12, status = "info",
                            tags$a(href="https://web.stanford.edu/~jurafsky/slp3/3.pdf", "Daniel Jurafsky & James H. Martin., \"N-gram Language Models - Stanford University\", Speech and Language Processing, Chapter 3, 2019")
                        )
                    )
            )
        ) # close tabsItems()
    ) # close dashboardbody()
) # close dashboardpage()
# End of Code