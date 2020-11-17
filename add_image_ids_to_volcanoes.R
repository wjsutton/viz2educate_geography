
vol <- read.csv('data/volcano_locations.csv',stringsAsFactors = F)
image_list <- list.files('volcano_images')

vol_image_tag <- substr(vol$Primary_Photo_Link,39,nchar(vol$Primary_Photo_Link))
vol$image_id <- ifelse(vol_image_tag %in% image_list,vol_image_tag,'NA')

write.csv(vol,'data/volcano_locations_with_image_ids.csv',row.names = F)
