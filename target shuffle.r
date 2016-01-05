## 
## Target Shuffle
##


data(Boston)

targetShuffle <- function(df, num.iters) {
  
  
    output <- list()
    
    # if(any(c('factor','character') %in% lapply(df, class))) {
    #   
    #   
    # }
    # 
    y <- select.list(sort(colnames(df)), title = 'Select Target Variable:')
  
    X <- as.matrix(df[,-grep(y, names(df))])
    Y <- as.matrix(df[,y])
    
    truth <- summary(lm(Y ~ X))$adj.r.squared
  
    
    temp <- unlist(lapply(seq_len(num.iters), function(i) {
      
      newOrder <- sample(nrow(Y))
      newY <- as.matrix(Y[newOrder,])
      
      return(summary(lm(newY ~ X))$adj.r.squared)
     
    }))
  
    output$adj.r.squared <- temp
    output$percentiles <- quantile(temp, probs = c(.05,.25,.5,.75,.95))
    
    output$true.value <- truth
    
    p <- ggplot(data = as.data.frame(x = temp), aes(temp)) +
      geom_histogram(color = 'white', alpha = .75) +
      xlab('Adjusted R-Squared') +
      ylab('Frequency') +
      ggtitle(paste('Adjusted R-Squared Over', num.iters, 'Iterations')) +
      theme_bw()
      #geom_vline(x = output$truth, color = 'red') +
      #geom_text(aes(x= output$truth, y = 10, label=paste('True Model')),
                #colour="red", size = 3, hjust = 1.25)
    
    output$p <- p
    
    return(output)  
  
    
}

