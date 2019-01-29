

## Exercise 1: Writeup

rubric={reasoning:25}

The focus of  Milestone 4 was to improve our app as much as possible. In Milestone 3 we managed to fix the majority of the bugs occurring. We fixed the error message when any of the filters were unselected and we redesigned our bar chart on the second tab (that was missing hour 0 and 23). With these previous changes, we believe that we improved it in such a way that if we kept tampering with it too much it would potentially jeopardize our design and functionality of the app. 

One bug we discovered while examining the bar chart was the width of the bars were inconsistent with certain selected filters. This was resolved by using a new layer of ggplot called " stat_count" with a  geom  = "bar" parameter.  

In an attempt to better our app we tried 2 things, however only implemented one change.   Both feedback sessions from Milestone 3 suggested changing the colour palette from 'viridis' to a binary gradient. At first, we disagreed, however, after reflecting we concluded that it was likely the best option to capture density as a quantitative measure. We chose on a standard yellow to red palette to represent the severity of the number of crimes. 

One of the suggestions from the Milestone 3 feedback exercise was that we change the color of the selected tab in our navigation bar.  Unfortunately, the shiny package does not directly offer this kind of flexibility, and thus these changes fall on prior CSS knowledge and experience.  While we attempted to inject the custom CSS necessary for this task, we ended up just creating more problems than solutions, and thus in the interest of time, we ended up forgoing this suggestion.  

In hindsight, if we had the opportunity to remake this app, we would be more aware of our missing data. One of the things our app suffered from was the missing data for some of the neighbourhoods.  In the future, a better method would be to assign crimes to neighbourhood based on the coordinates instead of the already assigned districts. 

The greatest challenges we faced in creating this app was working with leaflet and merging our tabular data with our shapefile in order to colour our neighbourhoods based on aggregated data. Creating a polar coordinate plot was definitely a new type of challenge for us due to the novelty, however, as a team, we were able to effectively overcome both these challenges and produce an app that we think is not only estetically pleasing but user-friendly as well. 
