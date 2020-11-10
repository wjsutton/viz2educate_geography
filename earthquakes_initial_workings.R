

#http://ds.iris.edu/ieb/index.html?format=text&nodata=404&starttime=1970-01-01&endtime=2025-01-01&mindepth=0&maxdepth=900&orderby=time-desc&src=iris&limit=1000&maxlat=79.93&minlat=-57.35&maxlon=180.00&minlon=-180.00&caller=smevlnk&evid=11336206&zm=2&mt=sat
# Over 6M earthquakes -> may be too big for Tableau
# Filtering Magnitude 5-10 -> 84500 much more realist!

library(XML)

sample_call <- 'http://ds.iris.edu/ieb/evtable.phtml?caller=IEB&st=1970-01-01&et=2000-01-01&minmag=5&maxmag=10&mindepth=0&xde=900&orderby=time-desc&src=iris&limit=1000&maxlat=90.00&minlat=-90.00&maxlon=180.00&minlon=-180.00&caller=smevlnk&evid=11336206&zm=2&mt=sat&title=IEB%20export%3A%2025000%20earthquakes%20as%20a%20sortable%20table.&stitle=from%20the%20earliest%20to%202000-01-01%2C%20with%20magnitudes%20from%205%20to%2010%2C%20depths%20from%200%20to%20900%20km%2C%20with%20priority%20for%20most%20recent%2C%20limited%20to%2025000%2C%20%20showing%20data%20from%20IRIS%2C%20'
sample_html <- read_html(sample_call)
html_doc <- XML::htmlParse(sample_html)
sample_earthquakes_df <- XML::readHTMLTable(html_doc)$evTable


start <- seq(as.Date('1970-01-01'), as.Date('2025-01-01'), "5 years")
end <- seq(as.Date('1974-12-31'), as.Date('2029-12-31'), "5 years")
for(i in 1:length(start)){
  start_date <- start[i]
  end_date <- end[i]
  
  call <- paste0('http://ds.iris.edu/ieb/evtable.phtml?caller=IEB&st=',start_date,'&et=',end_date,'&minmag=5&maxmag=10&mindepth=0&xde=900&orderby=time-desc&src=iris&limit=25000&maxlat=90.00&minlat=-90.00&maxlon=180.00&minlon=-180.00&caller=smevlnk&evid=11336206&zm=2&mt=sat&title=IEB%20export%3A%2025000%20earthquakes%20as%20a%20sortable%20table.&stitle=from%20the%20earliest%20to%202000-01-01%2C%20with%20magnitudes%20from%205%20to%2010%2C%20depths%20from%200%20to%20900%20km%2C%20with%20priority%20for%20most%20recent%2C%20limited%20to%2025000%2C%20%20showing%20data%20from%20IRIS%2C%20')
  html <- read_html(call)
  html_doc <- XML::htmlParse(html)
  call_df <- XML::readHTMLTable(html_doc)$evTable
  print(nrow(call_df))
  
  if(i == 1){
    earthquakes_df <- call_df 
  }
  if(i != 1){
    earthquakes_df <- rbind(earthquakes_df,call_df)
  }
  
  Sys.sleep(60*2)
  
}

write.csv(earthquakes_df,'data/earthquakes_mag_5_to_10.csv',row.names = F)