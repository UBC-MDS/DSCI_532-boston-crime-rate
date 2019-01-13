# Milestone 1 : Proposal

Contributors:
- [Anthony Chiodo](https://github.com/apchiodo)
- [Hayley Boyce](https://github.com/hfboyce)



### Section 1: Overview

A spatial understanding of crime rates across the district boundaries of a city is important information for a variety of reasons.  For example, it can provide city managers/planners with an general idea of how to allocate municipal resources such as the police force, fire fighters, and emergency medical services.  For those looking to rent or purchase a new property, it can provide information on neighborhood safety.  In terms of tourism, it can inform travelers on areas they may wish to avoid.  The purpose of this app will allow its users to visualize criminal records based on municipal locality, time of day, and extent of crime.


### Section 2: Description of the data

This Dataset was approved by our lab TA - Joel Ostblom on January 7th 2019

**Tabular Data:**
[Crimes in Boston]( https://www.kaggle.com/ankkur13/boston-crime-data/home)

**Spatial Data:** [Boston Neighbourhoods]( http://bostonopendata-boston.opendata.arcgis.com/datasets/3525b0ee6e6b427f9aab5d0a1d0a1a28_0)

We will be using a dataset that contains 328,000 different criminal incidents in various Boston districts between the years 2015-2018. A [secondary dataset]( http://bostonopendata-boston.opendata.arcgis.com/datasets/3525b0ee6e6b427f9aab5d0a1d0a1a28_0) provides that spatial information needed to be used in conjunction with the [Crimes in Boston]( https://www.kaggle.com/ankkur13/boston-crime-data/home)  dataset in order to visualize the data by corresponding neighborhood. We will be joining the two datasets using a _district code_ as a key and discarding any incidents missing this information.

* The INCIDENT_NUMBER will be the unique ID key with each incident having 14 variables:

* Criminal Offense type: OFFENSE_CODE, OFFENSE_CODE_GROUP and OFFENSE_DESCRIPTION, SHOOTING
These all describe the specific type of incident that occurred and `SHOOTING` as a binary variable indicating whether  a shooting was involved

* Location: DISTRICT, REPORTING_AREA, Lat, Long and we will be creating a new variable (NEIGHBOURHOOD_NAME) with the neighbourhood name based on DISTRICT  
These variables will be used to determine the location within the city of Boston in order to categorize it into specific neighbourhoods for our visualization

* Time: OCCURRED_ON_DATE, YEAR, MONTH, DAY_OF_WEEK, HOUR  


### Section 3: Usage scenario & tasks

Brenda, an anxious Vancouver local works in sales for a beverage distributor. At her most recent team meeting, she discovers that she will have to fly to Boston for 5 days to pitch to a potential client. Brenda travels often but she has never been to Boston before and has heard conflicting information about how safe the city in by various sources. Brenda also got recommended a great hotel by her colleague near the Charles River and is eager to see if it's a viable place to stay during her trip. She wants to know what time of precautions she be taking on her trip and how to make her travels as safe as possible. 

Brenda lives in Point Grey and doesn't quite know what to expect so she is interested in [exploring] what type of crime can be expected near her client's office. Brenda wants to [compare] which neighbourhoods are safer in the evenings to help in her decision on particular hotels. Brenda uses the Boston Criminal Incident Shiny application and is able to select previous records between the years 2015-2018. She can filter based on the type of incident, the month she will be traveling and the day of the week. Brenda checks out the neighbourhood of the hotel her colleague recommended, however, she notices that during the times where she would be returning to the hotel after her sales pitch, there is an elevated number of theft incidents. She instead decides on a hotel closer to the office to limit her commute time and distance. She makes note that assault crimes are far more prominent in the neighbourhood where her client's office resides and decides that she will purchase some pepper spray as a precaution when she arrives in Boston.

### Section 4: Description of your app & sketch


This shiny application will contain 2 interactive graphics directed from a landing page. The main panel will contain a map of Boston, Massachusetts split between municipal districts and a bar chart below it.  The user has a choice of several filtering options all located on the side panel dashboard. They have the option to select data from a range of years between 2015 and 2018 by using a slider range bar. The specific severity of crime can then be selected or left at a default setting of  "All" by means of a dropdown menu.   The user can also filter the data by the month, calendar day, or day of the week, giving  more flexibility and precision. Radio buttons are provided giving the ability to refine the data further by neighbourhood. Using the selected parameter, the map will colour code the frequency of the specified incident(s) of all the city's districts. The color bar legend at the bottom of the screen informs the user on the magnitude. Hovering over a specific district on the map will expand the statistics and rank of that particular neighborhood in comparison to others. The bar chart beneath the map depicts a 24-hour clock displaying the frequency per hour of the specified incident for the neighbourhood selected in the side panel. 

![sketch](https://github.com/hfboyce/DSCI_532-boston-crime-rate/blob/master/img/proposal_sketch.png)
###### Figure 1: Sketch proposal for final shiny application 