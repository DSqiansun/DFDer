pacman::p_load(DiagrammeR, xlsx, plyr, igraph)


vars <- unique(res$Target)

fluidPage(  # Application title
    titlePanel(    h1("Data Flow: csv --> DFD", align = "center")),
    
    headerPanel('Loading CSV'),
    fileInput("csvFile", "Drag cars.csv over here!"),
    tableOutput("rawData"),

    pageWithSidebar(
        headerPanel('Select Target'),
        sidebarPanel(
            #selectInput('xcol', 'Target', vars),
            uiOutput("campSelector")
        ),
        mainPanel(
            DiagrammeROutput('plot1')
        )
)
)