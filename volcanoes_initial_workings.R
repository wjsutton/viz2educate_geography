
# Call Smithsonian webservice
# Reshape data
# Save files: volcano locations & eruptions

library(XML)
library(xml2)

# Sample 100 row output
sample_100 <- 'https://webservices.volcano.si.edu/geoserver/GVP-VOTW/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=GVP-VOTW:Smithsonian_VOTW_Holocene_Volcanoes&maxFeatures=100'
sample_xml <- xml2::read_xml(sample_100)
doc <- XML::xmlParse(sample_xml)
sample_df <- XML::xmlToDataFrame(getNodeSet(doc, "//GVP-VOTW:Smithsonian_VOTW_Holocene_Volcanoes"))

# Holocene Volcano Output
holocene_volcanoes <- 'https://webservices.volcano.si.edu/geoserver/GVP-VOTW/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=GVP-VOTW:Smithsonian_VOTW_Holocene_Volcanoes'
holocene_xml <- xml2::read_xml(holocene_volcanoes)
holocene_doc <- XML::xmlParse(holocene_xml)
holocene_df <- XML::xmlToDataFrame(getNodeSet(holocene_doc, "//GVP-VOTW:Smithsonian_VOTW_Holocene_Volcanoes"))
holocene_df$volcano_type <- 'Holocene'

# Pleistocene Volcano Output
pleistocene_volcanoes <- 'https://webservices.volcano.si.edu/geoserver/GVP-VOTW/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=GVP-VOTW:Smithsonian_VOTW_Pleistocene_Volcanoes'
pleistocene_xml <- xml2::read_xml(pleistocene_volcanoes)
pleistocene_doc <- XML::xmlParse(pleistocene_xml)
pleistocene_df <- XML::xmlToDataFrame(getNodeSet(pleistocene_doc, "//GVP-VOTW:Smithsonian_VOTW_Pleistocene_Volcanoes"))
pleistocene_df$volcano_type <- 'Pleistocene'

# Add columns to Pleistocene to match Holocene
pleistocene_df$Last_Eruption_Year <- NA
pleistocene_df$Tectonic_Setting <- NA
pleistocene_df$Evidence_Category <- NA
pleistocene_df$Primary_Photo_Link <- NA
pleistocene_df$Primary_Photo_Caption <- NA
pleistocene_df$Primary_Photo_Credit <- NA
pleistocene_df$Major_Rock_Type <- NA

# Reorder columns and merge datasets 
pleistocene_df <- pleistocene_df[c(names(holocene_df))]
volcano_locations_df <- rbind(holocene_df,pleistocene_df)

# Eruption Output
holocene_eruptions <- 'https://webservices.volcano.si.edu/geoserver/GVP-VOTW/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=GVP-VOTW:Smithsonian_VOTW_Holocene_Eruptions'
eruption_xml <- xml2::read_xml(holocene_eruptions)
eruption_doc <- XML::xmlParse(eruption_xml)
eruption_df <- XML::xmlToDataFrame(getNodeSet(eruption_doc, "//GVP-VOTW:Smithsonian_VOTW_Holocene_Eruptions"))

write.csv(volcano_locations_df,'data/volcano_locations.csv',row.names = F)
write.csv(eruption_df,'data/volcano_eruptions.csv',row.names = F)
