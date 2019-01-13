# Milestone 1 : Proposal

Contributors:
- [Anthony Chiodo](https://github.com/apchiodo)
- [Hayley Boyce](https://github.com/hfboyce)



### Section 1: Overview

A spatial understanding of crime rates across the district boundaries of a city is important information for a variety of reasons.  For example, it can provide city managers/planners with an general idea of how to allocate municipal resources such as the police force, fire fighters, and emergency medical services.  For those looking to rent or purchase a new property, it can provide information on neighborhood safety.  In terms of tourism, it can inform travelers on areas they may wish to avoid.  The purpose of this app will allow its users to visualize criminal records based on municipal locality, time of day, and extent of crime.

Like any typical city, it is good knowledge for the city to know what type of crime is expected in certain areas of the city. This helps properly allocate the necessary resources to the needed areas, helping manage and prevent these specific types of crimes. It can also be used by tourists as a resource to help plan their visit to ensure safety or even locals attempting to find a place to rent or own. We are attempting for this milestone to create a shiny application that visualizes the data of criminal records by location and type. We hope to make the app interactive by allowing the user see the crime rate as a type of heat map, with the ability to filter by several different features including the day of the week, month and specific day.


### Section 2: Description of the data

This Dataset was approved by our lab TA - Joel Ostblom

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

Next month, Brenda, a Vancouver local, will be taking a business trip to Boston. She will be staying for 5 days and is curious about what precautions she should take before traveling.  Brenda wants to [compare] which neighbourhoods are safer in the evenings to help in her decision on particular hotels. Brenda lives in Point Grey and doesn't quite know what to expect so she is interested in [exploring] what type of crime can be expected near her company's office. Brenda uses the Boston Criminal Incident Shiny application and is able to filter based on the type of incident, the month she will be travelling. She can select an exact date of criminal activities from between the years 2015-2018.  Brenda wishes to stay in a hotel near the Charles River, however, she notices that during the times where she would be traveling back to the hotel there is an elevated number of theft incidents and instead decides on a hotel closer to the office to limit her commute time and distance. She makes note that assault crimes are far more prominent in the neighbourhood where her office resides and decides that she will purchase some pepper spray as a precaution when she arrives in Boston.
