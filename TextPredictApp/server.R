library(data.table)
library(quanteda)
library(shiny)
library(shinydashboard)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    QuadTab <- reactive({
        InputWords <- input$InputId
        QuadCal <- WordPredict(InputWords)
        QuadAll <- subset(QuadCal, QuadCal$model == 'quadgram')
        paste(as.vector(QuadAll)[,c(1)], collapse = ", ")
    })

    TriTab <- reactive({
        InputWords <- input$InputId
        TriCal <- WordPredict(InputWords)
        TriAll <- subset(TriCal, TriCal$model == 'trigram')
        paste(as.vector(TriAll)[,c(1)], collapse = ", ")
    })
    
    BiTab <- reactive({
        InputWords <- input$InputId
        BiCal <- WordPredict(InputWords)
        BiAll <- subset(BiCal, BiCal$model == 'bigram')
        paste(as.vector(BiAll)[,c(1)], collapse = ", ")
    })
    
    UniTab <- reactive({
        InputWords <- input$InputId
        UniCal <- WordPredict(InputWords)
        UniAll <- subset(UniCal, UniCal$model == 'unigram')
        paste(as.vector(UniAll)[,c(1)], collapse = ", ")
    })
    
    output$Quadgram <- renderText({
        QuadTab()
    })

    output$Trigram <- renderText({
        TriTab()
    })
    
    output$Bigram <- renderText({
        BiTab()
    })
    
    output$Unigram <- renderText({
        UniTab()
    })
    
    output$NumQuad <- renderValueBox({
        QuadWSep <- unlist(strsplit(QuadTab(), ", "))
        NumQuad <- length(QuadWSep)
        valueBox(NumQuad, "Quadgram", color = 'blue', icon = icon("grin-beam"), href = "https://en.wikipedia.org/wiki/N-gram")
    })
    
    output$NumTri <- renderValueBox({
        TriWSep <- unlist(strsplit(TriTab(), ", "))
        NumTri <- length(TriWSep)
        valueBox(NumTri, "Trigram", color = 'green', icon = icon("smile"), href = "https://en.wikipedia.org/wiki/N-gram")
    })
    
    output$NumBi <- renderValueBox({
        BiWSep <- unlist(strsplit(BiTab(), ", "))
        NumBi <- length(BiWSep)
        valueBox(NumBi, "Bigram", color = 'yellow', icon = icon("meh"), href = "https://en.wikipedia.org/wiki/N-gram")
    })
    
    output$NumUni <- renderValueBox({
        UniWsep <- unlist(strsplit(UniTab(), ", "))
        NumUni <- length(UniWsep)
        valueBox(NumUni, "Unigram", color = 'red', icon = icon("frown"), href = "https://en.wikipedia.org/wiki/N-gram")
    })
})
