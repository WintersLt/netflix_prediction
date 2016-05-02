calculate_roc <- function(answers_yr, cost_of_fp, cost_of_fn, predTst, n=100) {
  tpr <- function(answers_yr, threshold, predTst) {
    sum(predTst >= threshold & answers_yr$is_rated == 1) / sum(answers_yr$is_rated == 1)
  }
  
  fpr <- function(answers_yr, threshold, predTst) {
    sum(predTst >= threshold & answers_yr$is_rated == 0) / sum(answers_yr$is_rated == 0)
  }
  
  cost <- function(answers_yr, threshold, cost_of_fp, cost_of_fn, predTst) {
    sum(predTst >= threshold & answers_yr$is_rated == 0) * cost_of_fp + 
      sum(predTst < threshold & answers_yr$is_rated == 1) * cost_of_fn
  }
  
  roc <- data.frame(threshold = seq(0,1,length.out=n), tpr=NA, fpr=NA)
  roc$tpr <- sapply(roc$threshold, function(th) tpr(answers_yr, th, predTst))
  roc$fpr <- sapply(roc$threshold, function(th) fpr(answers_yr, th, predTst))
  roc$cost <- sapply(roc$threshold, function(th) cost(answers_yr, th, cost_of_fp, cost_of_fn, predTst))
  
  return(roc)
}