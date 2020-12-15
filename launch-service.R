library(plumber)

PORTEnv <- Sys.getenv("FUNCTIONS_CUSTOMHANDLER_PORT")
PORT <- strtoi(PORTEnv , base = 0L)
if(is.na(PORT)) PORT <- 8000

message(paste0("Launching server listening on :", PORT, "...\n"))

pr("handler.R") %>%
  pr_run(port=PORT)