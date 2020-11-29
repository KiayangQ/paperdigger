#' Download paper from sci hub
#'
#' @param path The file path of the input data
#' 
#' @param input_url sci url, if not offered by the user, sci-hub.se will be used
#' 
#' @param original The source of your input data,  "Database" means the data is from a database e.g. web of science. "Dois" means you collected dois by your self as a text file.  
#' 
#' 
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @importFrom purrr map2
#' @importFrom purrr safely
#' @importFrom purrr map_dbl
#' @importFrom purrr map
#' @importFrom purrr discard

sci_loc <- function(path,input_url=NULL,original){


  data_bib <- read_bib(path,original)
  dois <- data_bib$dois

  
  
  if (is.null(input_url)){
    url <- "http://sci-hub.se"
  }else{
    if (stringr::str_detect(input_url,"//sci-hub")){
      url <- input_url
    }else{
      stop("Please input a correct sci-hub url or use the default.")
    }
   
  }
  
  
    pb <- progress::progress_bar$new(total = length(dois))
    added <- round(runif(1,min=10000,max=99999))
    dir_name <- paste0("paper",added)
    dir.create(file.path(dir_name))
    loc_get <- purrr::map2(dois,dir_name,purrr::safely(function(x,y) {
     
        pb$tick()
        data1 <- sci_down_orginal(url=url,dois=x,dir=y)
        
       
      value <-  match(x,dois)
      setProgress(value = value)
      Sys.sleep(2)
      return(data1)
    },
    otherwise = message("Some links may not work, please check them and download manually"))) %>% 
      purrr::transpose()


  
  
  
  
  success <- purrr::map_dbl(loc_get$error,function(x){
    note <- c()
    if (is.null(x)){
      failure=1
    }else{
      failure=0
    }
    rbind(note,failure)
  })
  
  data <- purrr::map(loc_get,~ purrr::discard(.x, is.null))$result %>% unlist() %>% as.data.frame(.,stringsAsFactors = FALSE)
  locs <-  data$. %>% stringr::str_split(., "#") %>% purrr::map_chr(.,function(x)`[[`(x,1) %>% `[`(.,1))
 if(original=="Database") {
  index <- data.frame(title=data_bib$title,dois=data_bib$dois,success)
 }else if(original=="Dois"){
  index <- data.frame(dois=dois,success)
 }
  output <- list(locs=locs,index=index)
  return(output)
}
