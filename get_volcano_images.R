library(httr)

vol <- read.csv('data/volcano_locations.csv',stringsAsFactors = F)

images <- unique(vol$Primary_Photo_Link)
images <- images[!is.na(images)]

for(i in 1:length(images)){
  
  if(http_status(GET(images[i]))$category == 'Success'){
    
    download.file(images[i],paste0('volcano_images/',substr(images[i],39,nchar(images[i]))), mode = 'wb')
    Sys.sleep(5)
  }
  
  if(i %% 10 == 0){
    print(paste0(i," done!"))
  }
  
}

