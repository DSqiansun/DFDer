pacman::p_load(DiagrammeR, xlsx, plyr, igraph, data.table)

function(input, output, session) {
  
  
  
  #file <- '../DAGs.xlsx'
  #res <- read.xlsx(file, 1,stringsAsFactors=FALSE)  # Lire la prémière feuille
  # Combine the selected variables into a new data frame
  res <- eventReactive(input$csvFile, {
    #res = read.xlsx(input$csvFile$datapath, 1,stringsAsFactors=FALSE)
    res = fread(input$csvFile$datapath,stringsAsFactors=FALSE,na.strings = 'nan', file =  )
    res[is.na(res)] = ' '
    res
  })
  
  output$rawData <- renderTable({
    res() %>% head
  })
  
  output$campSelector <- renderUI({
    selectInput("variable1", "Choose Option:", as.list(res()$`Target`)) 
  })
  
  
  
  output$plot1 <- renderDiagrammeR({
    print(res()[, c('Depenecy', 'Target' )])
    g <- graph_from_data_frame(res()[, c('Depenecy', 'Target' )], directed=TRUE)
    target=input$variable1
    sub_g <- make_ego_graph(g, order=length(V(g)), nodes=target, mode="in")
    print(sub_g)
    sub_data <- rename(as_data_frame(sub_g[[1]], what="edges"),c('from'='Depenecy', 'to'='Target') )
    res_data <- merge(sub_data,res(), by=c("Depenecy" ,"Target"))
    res_data[is.na(res_data)] = '1'
    res_data$operation[res_data$operation==''] <- ' '
    
    print(res_data)
    
    
    unique_values <- union(res_data$Target, res_data$Depenecy)
    new_id <- as.numeric(as.factor(sort(unique_values)))
    key_value <- data.frame(new_id, unique_values)
    
    data <- merge(res_data, rename(key_value,c('new_id'='Target_id') ), by.x = "Target", by.y = "unique_values") %>%
      merge(., rename(key_value,c('new_id'='Depenecy_id') ), by.x = "Depenecy", by.y = "unique_values")
    
    
    header <- "
graph LR
"
    paste_data <- paste0(data$Depenecy_id,'[',data$Depenecy,']-->|',data$operation, '|', data$Target_id,'[', data$Target, ']')
    graph <- paste0(header,paste(paste_data, collapse="\n"))
    
    
    mermaid(graph)
    
  })
  
}