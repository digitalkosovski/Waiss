##install.packages("leaflet")
##install.packages("sp")
##install.packages("rgdal")
##install.packages("RColorBrewer")
##install.packages("leaflet.extras")
##install.packages("leaflet.minicharts")
##install.packages("htmlwidgets")
##install.packages("raster")
##install.packages("mapview")
##install.packages("leafem")

## Call the libraries
library(leaflet)
library(sp)
library(rgdal)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(leafpop)
library(sf)
library(htmltools)

## PART 1 - IN THIS PART THE CODE READS THE FILES AND ATTRIBUTES COLORS AND ICONS TO ELEMENTS

## Read the shapefile
countries <- readOGR('Shapes/Shapes.shp')

## Create the palette of colors for the shapefiles
#palette_countries <- colorNumeric(palette = "YlOrRd", domain = countries$victimas)

## Create an image through the use of a link
url <- "https://i.redd.it/3t167338scj21.png"
## url <- data$url
psp_icon <-  makeIcon(url, url, 35, 20)

intro <- paste(sep = "<br/>",('In 1955, Chilean socialist intellectual Oscar Waiss visited Yugoslavia.'),
          paste0('The map the places visited by Waiss, along with his impressions, as told in the book "Amanecer en Belgrado". 
          It also allows the user to compare it to the one carried out by socialist leader Raúl Ampuero in 1957'))


## Read the csv
data_w <- read.csv("Waiss.csv")

data_a <- read.csv("Ampuero.csv")

## Create a html popup
content_w <- paste(sep = "<br/>",
                        paste0("<div class='leaflet-popup-scrolled' style='max-width:300px;max-height:300px'>"),
                        paste0("<em>","<b>", data_w$Place, "</b>", "</em>"),
                        paste0("<b>", data_w$img, "</b>"),
                        paste0("<b>", data_w$Site, "</b>"),
                        paste0(data_w$Comment),
                        paste0("</div>"))

content_a <- paste(sep = "<br/>",
        
                   paste0("<em>","<b>", data_a$Place, "</b>", "</em>"),
      
                   paste0("</div>"))

icon_w <- makeAwesomeIcon(icon= 'star', library='glyphicon', markerColor = 'red')

icon_a <- makeAwesomeIcon(icon= 'star', library='fa', markerColor = 'lightgray')

## PART 2 - IN THIS PART THE CODE ADDS ELEMENT ON THE MAP LIKE POLYGONS, POINTS AND IMAGES.

m <- leaflet() %>%
  ## Basemap
  ##addTiles(tile)        %>%
  addProviderTiles(providers$Stamen.Toner)  %>%
  
  ## Add a zoom reset button
  addResetMapButton() %>%
  ## Add a Minimap to better navigate the map
  addMiniMap() %>%
  ## Add a coordinates reader
  leafem::addMouseCoordinates() %>%
  ## define the view
  setView(lng = 18.413029, 
          lat =  43.856430, 
          zoom = 5.5 ) %>%

  
  ## Add the polygons of the shapefiles
  addPolygons(data = countries,
              stroke = FALSE, 
              smoothFactor = 0.2, 
              fillOpacity = 0.4,
              color = '#FF0000') %>%
  ## Add a legend with the occurrences of the toponyms according to the macro areas
  #addLegend("bottomleft", 
       #     pal = palette_countries, 
        #    values = countries$number,
         #   title = "Pizzerias by country:",
          #  labFormat = labelFormat(suffix = " pizzerias"),
           # opacity = 1,
            #group = "Countries") %>%
  
  ## Add Markers with clustering options
  addAwesomeMarkers(data = data_w, 
                    lng = ~lng,
                    lat = ~lat, 
                    popup = c(content_w),
                    icon = icon_w,
                    group = "Places Visited by Waiss",
                    options = popupOptions(maxWidth = 100, maxHeight = 150))%>%
  
  addAwesomeMarkers(data = data_a, 
                    lng = ~lng,
                    lat = ~lat, 
                    popup = c(content_a),
                    icon = icon_a,
                    group = "Places Visited by Ampuero (1957)",
                    options = popupOptions(maxWidth = 100, maxHeight = 150))%>%
  

  
  ## Add Circles with quatitative options
  #addCircleMarkers(data = data, 
  #                 lng = data$lng,
   #                lat = data$lat,
    #               fillColor = ~palette_data(price_euro_average),
     #              color = "black",
      #             weight = 1,
       #            radius = ~sqrt(data$price_euro_average) * 3,
        #           stroke = TRUE,
         #          fillOpacity = 0.5,
          #         group = "By price",
           #        label = ~paste("In the pizzeria ", data$name, 
            #                      " pizza costs approximately ",
             #                     data$price_euro_average, 
              #                    " euros")) %>%
  
  ## Add a legend with the occurrences of the toponyms according to the macro areas
  #addLegend("bottomleft", 
   #         pal = palette_data, 
    #        values = data$price_euro_average,
     #       title = "Pizzerias ordered by prices:",
      #      labFormat = labelFormat(suffix = " euros"),
       #     opacity = 1,
        #    group = "By price") %>%
  
## Add Markers with special icons
  #addMarkers(data = data,
   #          lng = ~lng, 
    #         lat = ~lat, 
     #        icon = psp_icon,
      #       group = "Sites",
       #      popup = ~paste0(Site)) %>%
  
  ## Add a legend with the credits
  addLegend("topright", 
            
            colors = 'transparent',
            labels=c(intro),
            opacity = 0.8,
            
            title="Oscar Waiss's Visit to Yugoslavia (1955)") %>%
  
 
  ## PART 3 - IN THIS PART THE CODE MANAGE THE LAYERS' SELECTOR
  
  ## Add the layer selector which allows you to navigate the possibilities offered by this map
  
  addLayersControl(baseGroups = c("Socialist Yugoslavia"),
                   position = 'topright',
                   
                   overlayGroups = c("Places Visited by Waiss", "Places Visited by Ampuero (1957)"),
                   
                   options = layersControlOptions(collapsed = FALSE)) %>%
  
  ## Hide the layers that the users can choose as they like
  hideGroup(c("Empty",
              "Places Visited", "Places Visited by Ampuero (1957)"))

## Show the map  
m

