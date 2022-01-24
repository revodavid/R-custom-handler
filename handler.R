#' Copyright(c) Microsoft Corporation.
#' Licensed under the MIT license.

library(plumber)
library(jsonlite)

# only load the model once to improve performance
model_path <- "."
model <- readRDS(file.path(model_path, "model.rds"))

#* Echo back the input
#* @param msg The message to echo
#* @get /api/msg
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Predict probability of fatality from params in body
#* @post /api/accident
function(params) {
  method <- model$method

  message(paste(method, "model loaded"))
  
  prediction <- predict(model, newdata=params, type="prob")[,"dead"]

  return(prediction)
}

