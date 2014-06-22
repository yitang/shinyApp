library(shiny)
library(ggplot2)
library(data.table)
# Define server logic required to draw a histogram


density_facet_ggplot <- function(dataX, dataY, cols = names(dataX)){
    require(data.table)
    require(ggplot2)
    require(reshape2)
    x <- as.data.table(dataX)[, cols, with=F] ## subset
    y <- as.data.table(dataY)[, cols, with=F]
    xy <- rbind(x, y)
    xy[, dataset := rep(
                     c(deparse(substitute(dataX)), deparse(substitute(dataY))),
                     c(NROW(dataX), NROW(dataY)))]
    ggdf <- melt(xy, id="dataset")
    p <- ggplot(ggdf, aes(x = value, col = dataset)) + geom_density() + facet_wrap(~ variable, scale = "free")
    return(p)
}


shinyServer(function(input, output) {
    ## read csv file
    data1 <- reactive({
        inFile1 <- input$file1
        if (is.null(inFile1))
            return(NULL)
        read.csv(inFile1$datapath) ## need more options?
    })
    data2 <- reactive({
        inFile2 <- input$file2
        if (is.null(inFile2))
            return(NULL)
        read.csv(inFile2$datapath) ## need more options?
    })

    ## common variable names in file1 and 2
    compare_cols <- reactive(function(){
        union( names(data1()), names(data2()))
    })

    ## render common variables to UI
  output$choose_columns <- renderUI({ #ref: https://gist.github.com/wch/4211337
    # If missing input, return to avoid error later in function
    if(is.null(input$file2))
      return()

    # Get the data set with the appropriate name
    colnames <- compare_cols()

    # Create the checkboxes and select them all by default
    checkboxGroupInput("columns", "Choose columns",
                        choices  = colnames,
                        selected = NULL)
  })
    ## plot section.                       #
    plotInput <- reactive(function(){   #produce ggplot object
        if (is.null(input$file1) | is.null(input$file2))
            return()
        if (is.null(input$columns))
            return()
        p <- density_facet_ggplot(data1(), data2(), input$columns) +
             scale_colour_discrete( "Data", breaks = c("dataX", "dataY"), labels = c(input$file1$name, input$file2$name)) + 
             labs(title = paste(input$file1$name, "v.s", input$file2$name, sep=" ") )
    })


    output$image <- renderPlot({ #render ggplot object to UI
        print(plotInput())
    })


    output$downloadImage <- downloadHandler( #save ggplot object to file
        filename <- function(){
            paste("image", ".png", sep="")
        },
        content = function(file){
            ## if (TRUE) # ggplot device
            ##     ggsave(file, plotInput)
            png(file, width = 1280, height = 960)
            print(plotInput())
            dev.off()
        })



})
