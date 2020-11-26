#' Download sci_hub paper main function
#'
#' 
#' @param url sci url, if not offered by the user, sci-hub\.se will be used
#' 
#' @param dois dois of a list of papers you want to download
#' 
#' @param dir the file directory where you put the paper downloaded
#' 
#' @import httr
#' @import rvest
#' @import ggplot2
#' @importFrom ggimage geom_image
#' @importFrom stringr str_detect
#' @importFrom stringr str_replace
#' @importFrom glue glue_collapse
sci_down_orginal <- function(url,dois,dir=NULL){
  url <- paste0(url,"/",dois)
  info <- httr::GET(url) %>% httr::content(.) 
  
  loc <- info %>% rvest::html_node(.,"iframe") %>% rvest::html_attr("src")
  if (stringr::str_detect(loc,"https")==FALSE){
    loc <-  stringr::str_replace(loc,"//","https://")
  }
  
  test_cap <-rvest::html_session(loc)
  sth <- stringr::str_detect(test_cap$response$headers$`content-type`,"text/html")
  while(sth){
    test_cap <-rvest::html_session(loc)
    image1 <- test_cap %>%  rvest::html_node(.,"#captcha") %>% rvest::html_attr("src")
    pattern <- "(?<=//)(.+?)(?=/)"
    datab <- stringr::str_extract(loc,pattern)
    image_loc <- paste0("https://", datab,image1)
    img <- ggplot2::ggplot()+ggimage::geom_image(ggplot2::aes(x=1,y=1,image=image_loc),size=1)+ggplot2::theme_void()
    print(img)
    ans <- readline("Input captcha please: ")
    # shinyalert::shinyalert(title = 'Input captcha!!', imageUrl =image_loc, type="input",inputType = "text", confirmButtonText = "OK",
    #                            cancelButtonText = "Cancel", showCancelButton = TRUE,  imageWidth = 500,imageHeight = 500,
    #                            showConfirmButton = TRUE,inputId = "shinyalert")
    
    signin <- html_form(test_cap)[[1]]
    filled <- set_values(signin,'answer'=ans)
    signined <-  submit_form(test_cap, filled)       
    sth <- stringr::str_detect(signined$response$headers$`content-type`,"text/html")         
    }


  
  

  pattern2 <- glue::glue_collapse(c(
      "zero_length"="(?<=/)",
      "others"=".+"
    ))  
  titles <-info %>% rvest::html_node(.,"title") %>% rvest::html_text() %>% stringr::str_extract(.,pattern2) %>%  paste0(.,".pdf")
    if (stringr::str_detect(loc,"https")==FALSE){
    loc <-  stringr::str_replace(loc,"//","https://")
  }
  download.file(loc,destfile=paste0(dir,"/",titles),mode = "wb")
  return(loc)
}