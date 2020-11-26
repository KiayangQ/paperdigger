#' read bibliographic data
#'
#' 
#' @param path file directory of your bibliographic data
#' 
#' @param original Source of the data
#' 

#' @importFrom tidyr separate
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom revtools read_bibliography

read_bib <- function(path,original){
  if (original=="Database"){
  options(warn = -1)
  data <- revtools::read_bibliography(path) %>% dplyr::select(.,title,doi) %>% 
      tidyr::separate(.,doi,into = c("dois","others"),sep = "Early") %>%
      dplyr::mutate(.,dois = ifelse(is.na(dois)!=TRUE,paste0("https://doi.org/",dois),NA))
  }else{
  data <- read.table(path,stringsAsFactors = FALSE)
  colnames(data)[1] <- "dois"
  }
  return(data)
}


# # science direct ris
# df <- revtools::read_bibliography("ScienceDirect_citations_1605438621362.ris") %>% select(.,title,doi) %>% 
#   separate(.,doi,into = c("dois","others"),sep = "Early") %>% 
#   mutate(.,dois = ifelse(is.na(dois)!=TRUE,paste0("https://doi.org/",dois),NA))
# 
# # ebsco host ris
# df <- revtools::read_bibliography("ebsco.ris") %>% select(.,title,doi) %>% 
#   separate(.,doi,into = c("dois","others"),sep = "Early") %>% 
#   mutate(.,dois = ifelse(is.na(dois)!=TRUE,paste0("https://doi.org/",dois),NA))
# 
# 
# # web of science bib
# df <- revtools::read_bibliography(input$files$datapath) %>% select(.,title,doi) %>%   
#   separate(.,doi,into = c("dois","others"),sep = "Early") %>% 
#   mutate(.,dois = ifelse(is.na(dois)!=TRUE,paste0("https://doi.org/",dois),NA))
# 
# # mendeley bib & ris
# df <- revtools::read_bibliography("men.bib") %>% select(.,title,doi) %>% 
#   mutate(.,dois = ifelse(is.na(doi)!=TRUE,paste0("https://doi.org/",doi),NA))
# 
