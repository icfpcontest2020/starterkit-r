#!/usr/bin/env Rscript

library(dplyr, warn.conflicts=FALSE); # needed for pipe operator '%>%'
library(httr); # needed for GET

commandArgs(TRUE)[1] -> SERVER_URL;
commandArgs(TRUE)[2] -> PLAYER_KEY;

paste0("ServerUrl: ", SERVER_URL, "; PlayerKey: ", PLAYER_KEY, "\n") %>%
  cat();

tryCatch(
    POST(SERVER_URL, body = PLAYER_KEY),
    error=function(error_message) {
        cat("Unexpected server response:\n")
        message(error_message)
        cat("\n")
        quit(save="no", status=1)
    }) -> res;

if(((nchar(content(res, as="text", encoding="UTF-8")) == 0)) || 
   (res$status_code != 200)){ # check html response code == 200
  cat("Unexpected server response:\n");
  cat("HTTP code: ", res$status_code, "\n", sep="");
  cat("Response body: ", content(res, as="text", encoding="UTF-8"), "\n", sep="");
  quit(save="no", status=2);
} else {
  cat("Server response: ", content(res, as="text", encoding="UTF-8"), "\n", sep="");
}

quit(save="no", status=0);
