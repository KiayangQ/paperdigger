#' read bibliographic data
#'
#' 
#' @param path file directory of your bibliographic data
#' 
#' @param original Source of the data."Database" means the data is from a database e.g. web of science. "Dois" means you collected dois by your self as a text file.  
#' 

#' @importFrom tidyr separate
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom revtools read_bibliography
#' @importFrom tools file_ext

read_bib <- function(path,original="Database"){
  if (original=="Database"){
  options(warn = -1)
    ext_files <- c("txt","csv")
    if (file_ext(path)%in%ext_files){
      stop("Please check the 'original' parameter or your data file, since 'Database' only works for '.bib' or '.ris', but not '.txt'or,'.csv'" )
    }
  data <- revtools::read_bibliography(path)
        if("doi"%in%colnames(data)){
        data <- data %>% dplyr::select(.,title,doi) %>% 
        tidyr::separate(.,doi,into = c("dois","others"),sep = "Early") %>%
        dplyr::mutate(.,dois = ifelse(is.na(dois)!=TRUE,paste0("https://doi.org/",dois),NA))
        }else{
          stop("No dois were detected, please check your data file")
        }
  }else{
  if (file_ext(path)%in%ext_files==FALSE){
    stop("Please check the 'original' parameter or your data file, since 'Dois' only works for '.txt'or,'.csv'" )
  }else{
    data <- read.table(path,stringsAsFactors = FALSE) %>% dplyr::select(stringr::str_detect("doi"|"DOI"|"Doi"))
    if (length(data)>1){
      stop("Please check your file,and make sure that only one column is named Doi." )
    }
    colnames(data)[1] <- "dois"
  }
  }
  return(data)
}

