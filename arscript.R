
library(shiny)
library(DBI)
library(pool)
library(ggplot2)
        
        pool <- dbPool(
          drv = RPostgres::Postgres(),
          dbname = "klohymim",
          host = "raja.db.elephantsql.com",
          user = "klohymim",
          password = "hwc3v4_rbkT-1EL2KI-JBaqFq0thCXM_",
        
      ##    dbname = "lndb",
      ##    host = "192.168.1.11",
      ##    user = "ln_admin",
      ##    password = "welcome",
      
          bigint = c("integer64", "integer", "numeric", "character")
        )

        values <- reactiveValues()
        values$ar_id <- 1
        


 
 ##   sql <- "SELECT  project_sys_name as "Project", descr as "Description" FROM project;"
 ##   query <- sqlInterpolate(pool, sql)
    
    conn <- poolCheckout(pool) 
    d <-dbGetQuery(conn, paste0("SELECT * FROM get_scatter_plot_data(1)"))
    d2 <-dbGetQuery(conn, paste0("SELECT * FROM assay_run_stats where assay_run_id =1;"))
    poolReturn(conn)
        
    response <- 1
    threshold <- 2
    
    ## 0 raw
    ## 1 norm
    ## 2 norm_pos
    ## 3 p_enhanced
    if(response ==0){
      ylabel <- "Background Substracted"
      df <- d[,c(2,3,5,9,12)]} 
    if(response ==1){
      ylabel <- "Normalized"
      df <- d[,c(1,2,5,8,11)]}
    if(response ==2){
      ylabel <- "Normalized to Positive Control"
      df <- d[,c(1,2,6,8,11)]}
    if(response ==3){
      ylabel <- "% Enhanced"
      df <- d[,c(1,2,7,8,11)]}
    
    
    ## Threshold
    ## 1  mean-pos
    ## 2  mean-neg-2-sd
    ## 3  mean-neg-3-sd
    
    if(threshold ==1){
     threshold.text <- "> mean(pos)"
      threshold_num <- d2[d2$response_type==response, "mean_pos" ]
    }
    if(threshold ==2){
    threshold.text <- "mean(neg) + 2SD"
      threshold_num <- d2[d2$response_type==response, "mean_neg_2_sd" ]
    }
    if(threshold ==3){
     threshold.text <- "mean(neg) + 3SD"
      threshold_num <- d2[d2$response_type==response, "mean_neg_3_sd" ]
    }
    
    names(df) <- c("plate","well","response","type","sid")
    df <- df[order(df$response),]
    df$index <- (nrow(df)):1
    num.hits <- nrow(df[df$response > threshold_num & df$type==1,])
    hit.array <-"{"
    counter <- 0
    for(i in 1:nrow(df)){
      if(counter==num.hits){
        break
        }else{
          if(df[i,"type"]==1){
            hit.array <- paste0(hit.array, df[i,"sid"],"," )
            counter <- counter +1}
      }
    }
    hit.array <- substring(hit.array,1, nchar(hit.array)-1)
    hit.array <- paste0(hit.array,"}")
  hit.list <- hit.array ##keep the reactive value out of a loop??  
    plot(df$index, df$response, main=paste0("Plot for AR-", values$ar_id, "; Hit count: ", values$num.hits), cex=1, pch=1, col=c("black", "green", "red", "grey")[df$type], ylab=ylabel, xlab="Index")
     text( nrow(df)*0.1, threshold_num - 0.05*threshold_num, threshold.text)
    legend("topright",  c("unknown","positive","negative","blank"), fill=c("black", "green", "red", "grey"))
    abline(h=threshold_num, lty="dashed")

})
  
 
  observeEvent(input$make_hit_list, {
    updateTabsetPanel(session, "maintabs",
                      selected = "tab2")
  })
 
observeEvent(input$load_hit_list, {

sqlstmnt1 = "SELECT new_hit_list ($1,$2,$3,$4,$5,$6);"
sqlstmnt2 = "SELECT hitlist_sys_name AS \"Sys Name\", hitlist_name AS \"Name\", descr AS \"Description\", n AS \"# hits\" FROM hit_list where assay_run_id= $1 ORDER BY id DESC" 
sqlstmnt3 = "SELECT sample_id AS \"Sample ID\" FROM hit_sample where hl_id = $1"
conn <- poolCheckout(pool) 
dbGetQuery(conn, sqlstmnt1, list(input$hl_name,input$hl_descr,values$num.hits,values$ar_id,1,values$hit.list))
output$hl_for_ar = DT::renderDataTable({
  dbGetQuery(conn, sqlstmnt2, list(values$ar_id))
})
poolReturn(conn)

updateTabsetPanel(session, "maintabs", selected = "tab3")

 output$ar_id <- renderText(paste0("Hit Lists for AR-", as.character(values$ar_id)))

  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
