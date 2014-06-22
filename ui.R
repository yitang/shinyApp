library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(

    ## Application title
    titlePanel("Hello Shiny!"),

    ## Sidebar with a slider input for the number of bins
    sidebarPanel(
        ## sliderInput("bins",
        ##             "Number of bins:",
        ##             min = 1,
        ##             max = 50,
        ##             value = 30),
        ## dateRangeInput("dateRange", "Input date range"), #
        fileInput("file1", "input file 1", multiple = FALSE),
        fileInput("file2", "input file 2", multiple = FALSE),
        ## checkboxGroupInput("cols", "columns to compare: ",
        ##                    c("Col1" = "col1",
        ##                      "Col2h" = "col2")),
        uiOutput("choose_columns"),


        submitButton(text = "Compare", icon = NULL),
        downloadButton("downloadImage", "Download plot", class = NULL)


        ),
    ## main part
    mainPanel(
        plotOutput("image")
        )
    ))


##                              # UI side
## fileInput("file1", "input file 1", multiple = FALSE)
## fileInput("file2", "input file 2", multiple = FALSE)
## chekcboxGroupInput("cols", "columns to compare: ",
##                    c("Col1" = "col1",
##                      "Col2" = "col2"))
## submitBotton(text = "Go compare", icon = NULL)
## downloadButton("downloadImage", "Download", class = NULL)


