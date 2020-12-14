library(httpuv)
library(webutils)
library(httr)

PORTEnv <- Sys.getenv("FUNCTIONS_CUSTOMHANDLER_PORT")
PORT <- strtoi(PORTEnv , base = 0L)

http_not_found <- list(
  status=404,
  body='404 Not Found'
)

http_method_not_allowed <- list(
  status=405,
  body='405 Method Not Allowed'
)

#' Copyright(c) Microsoft Corporation.
#' Licensed under the MIT license.

pred_accident <- function(req)
{
  newdata <- data.frame( # valid values shown below
    dvcat="10-24",        # "1-9km/h" "10-24"   "25-39"   "40-54"   "55+"  
    seatbelt="none",      # "none"   "belted"  
    frontal="frontal",    # "notfrontal" "frontal"
    sex="f",              # "f" "m"
    ageOFocc=16,          # age in years, 16-97
    yearVeh=2002,         # year of vehicle, 1955-2003
    airbag="none",        # "none"   "airbag"   
    occRole="pass"        # "driver" "pass"
)
  model_path <- "."
  model <- readRDS(file.path(model_path, "model.rds"))
  method <- model$method

  content_type <- req[["CONTENT_TYPE"]]
  body <- req[["rook.input"]]$read()
  postdata <- parse_http(body, content_type)

  message(paste(method, "model loaded"))
  message(paste("NAMES:", names(req)))
  message(paste("QUERY_STRING:",req$QUERY_STRING))
  message(paste("CONTENT_TYPE:",content_type))
  message(paste("BODY:",postdata))
  
  vars <- newdata
  prediction <- predict(model, newdata=vars, type="prob")[,"dead"]
  list(body=paste("Death:", prediction))
}

pred_handler <- list(
  GET = pred_accident,
  POST = pred_accident
)

routes <- list(
  '/api/accident' = pred_handler
)

router <- function (routes, request) {
  if (!request$PATH_INFO %in% names(routes)) {
    return(http_not_found)
  }
  path_handler <- routes[[request$PATH_INFO]]

  if (!request$REQUEST_METHOD %in% names(path_handler)) {
    return(http_method_not_allowed)
  }
  method_handler <- path_handler[[request$REQUEST_METHOD]]

  return(method_handler(request))
}

app <- list(
  call = function (request) {
    #message("STRREQ:",str(as.list(request)))
    response <- router(routes, request)
    if (!'status' %in% names(response)) {
      response$status <- 200
    }
    if (!'headers' %in% names(response)) {
      response$headers <- list()
    }
    if (!'Content-Type' %in% names(response$headers)) {
      response$headers[['Content-Type']] <- 'text/plain'
    }

    return(response)
  }
)

cat(paste0("Server listening on :", PORT, "...\n"))
runServer("0.0.0.0", PORT, app)