# Milestone 2 

## Functionality:





## Rationale

Displaying large amounts of data and particular a dataset such as ours can be difficult and confusing.  When constructing the set-up of this app, we really wanted to shows a clear picture that describes the crime rate in the Boston area but still giving the user the right amount of flexibility to answer their particular questions and curiosities. Leaflet was used to construct a map outlying Boston’s different districts and acts as a method to visually compare and contrast the neighbourhood’s crime frequency by means of the side legend. The second tab “Hourly Incident Graph” lets the user dig a little deeper in their analysis an see the particular crime frequency per hour of specific neighbourhoods from the ones depicted on the map. We used a specific type of select menu for versatility and precision. 

## Tasks

Based on our proposal the task in which we attempted to achieve in this Milestone were as followed: 

* **Map:** 
    * Create a map depicting the frequency of crimes in outlined neighbourhoods.
    * Merge shapefiles with leaflet map to outline the districts clearly. 
    * Have the districts reflect the frequency by means of colour. 
    
* **Build Graph:** 
    * Create a plot that shows the user the frequency (histogram) of crime occurring during the selected months, in the specified neighbourhoods. 
    
* **multi-select filtering:**    
    * After getting feedback from our TA, we agreed with his suggest to have multi-selection options for the type of crime. This prove, slightly more difficult than anticipated however all filtering of the data is in perfect working order. 


## Vision & Next Steps

One of our biggest goals is to implement a hover using leaflet on our map. We want to output the name of the neighbourhood, the values of the selected filtering incidents and how they rank in comparison to other neighbourhoods.
Navigation could be an issue as the tabs are quite small and unclear and therefore I would like to explore the option to perfect this in a more obvious and friendly way.
Having the single graph on the second tab seems quite lonely and potentially adding addition statistics could be of help to the user when analyzing this data and answer their questions. 
Currently all of the selecting options on the sidebar are all the same and this was thought out in the design for flexibility, however, I believe there to be a nicer way to select the filters that will keep the usability. 
In addition to these goals, we believe there is still a lot of work to do on the formatting on the minor detail to improve the overall experience. Text fonts and sizes, as well as sidebar and main panel colours This should be addressed in the next milestone.  
## Bugs

* Currently, when you deselect every feature on a filter, an error is displayed in the main panel and no map is outputted. An empty graph is displayed when no selection is chosen for any of the features. We are hoping to add a mandatory “at least one” function to prohibit an empty selection on a filter. 
* We have added a “close window feature” which will close the app however not the window. I believe this could be a browser issue. Fixing this or removing this feature will be on the task list for milestone 3. 