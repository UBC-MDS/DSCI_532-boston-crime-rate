# Milestone 3

#### Reflection on the usefulness of the feedback you received.


>The feedback sessions definitely lead to an improved app. The two most valuable parts were (1) the suggestion to implement a hover feature and (2) to change the histogram from a standard chart to a circular chart laid out on a polar coordinate system. With the hover feature implemented, users are now able to see district names associated with each polygon in the shapefile. This makes the app much more informative to users outside of Boston who might not be familiar with the city layout. Furthermore, the user is able to interact with each shapefile through a click in order to get an exact "Activity Count" (or the number of crimes according to the user-defined filter).
>
>The histogram, in our opinion, is much better suited as a circular plot. Since the x-axis represents "hours in a day", a circular plot makes the histogram feel almost like a clock.
>
>One thing we thought was unreasonable to change was the color palette associated with our count data. Initially, we chose to use 'Viridis', and in the end, we decided to stay with that. Our feedback sessions recommended that we change this palette to a single hue with an intensity gradient, however, when we tried this we found that the app was no longer as visually appealing. In our "Visualization II" course, we learned that there is in fact value in making maps and plots look good if they are user-facing (especially if it's only at the cost of slight effectiveness).
> 
> Another unanimously agreed upon improvement was to fix the error message that occurred with no selection was chosen for any of the filtering options. This was luckily a quick fix and we were able to improve the usability of the app immensely by resolving this.  

#### Reflection on how your project has changed since Milestone 2, and why.

>Bar none, the hardest thing to implement in shiny was merging our tabular data with our shapefile in order to colour our polygons based on aggregated data. It was definitely time-consuming, however, we knew it could be done... it was just a matter of hacking our way through the problem.

>We also came across some limitations with the leaflet package for R. We found that it doesn't handle the hover and pop-up features as nicely as we hoped, however, with some work we were still able to get those features to work despite them not appearing as we wish.