# DSCI_532-boston-crime-rate
The development of a shiny app using the city of Boston's crime rate. 


### Section 1: Overview

Like any typical city, it is good knowledge for the city to know what type of crime is expected in certain areas of the city. This helps to properly allocate the necessary resources to these areas in order to manage it and preventing these specific types of crimes. We are attempting for this milestone to create a shiny application that visualizes the data of criminal records by location and type. We hope to make the app interactive by allowing the user see the crime rate as a type of heat map, with the ability to filter by several different features including the day of the week, month and specific time of day which will help in the proper allocation of resources to the necessary area and time. 


### Section 2: Description of the data

[Crimes in Boston]( https://www.kaggle.com/ankkur13/boston-crime-data/home)
[Boston Neighbourhoods]( http://bostonopendata-boston.opendata.arcgis.com/datasets/3525b0ee6e6b427f9aab5d0a1d0a1a28_0)

We will be using a dataset describing 328,000 different criminal incidents in various Boston neighbors over the years 2015-2018. A [secondary dataset]( http://bostonopendata-boston.opendata.arcgis.com/datasets/3525b0ee6e6b427f9aab5d0a1d0a1a28_0)  is needed to be used in conjunction with the [Crimes in Boston]( https://www.kaggle.com/ankkur13/boston-crime-data/home)  set in order visualize the data by corresponding neighborhood. We will be joining the two datasets using the name of the neighbourhood and discarding any incidents missing this information. 
will be using the incident number as the unique ID key with each incident having 14 variables:

* Criminal Offense type: OFFENSE_CODE, OFFENSE_CODE_GROUP and OFFENSE_DESCRIPTION, SHOOTING
These all describing the specific type of incident that occurred and `SHOOTING` as a binary variable indicating whether  a shooting was involved 

* Location: DISTRICT, REPORTING_AREA, Lat, Long  and we will be creating a new variable with the neighbourhood name based on DISTRICT (NEIGHBOURHOOD_NAME) 
These variables will be used to determine the location within the city of Boston in order to categorized it into specific neighbourhoods for our visualization 

* Time: OCCURRED_ON_DATE, YEAR, MONTH, DAY_OF_WEEK, HOUR 
Used as a filter for the visualization (I don’t know what else to put here….) 





### Section 3: Usage scenario & tasks



### Section 4: Description of your app & sketch