# freedomhouse-tidy-ratings

Script to parse, wrangle, and rearrange Freedom House yearly ratings in a tidy format.

[Freedom House's ratings](https://freedomhouse.org/sites/default/files/Country%20and%20Territory%20Ratings%20and%20Statuses%20FIW1973-2018.xlsx) go back to 1973. 

According to the [Freedom House website](https://freedomhouse.org/report-types/freedom-world)

> Freedom in the World is Freedom House’s flagship annual report, assessing the condition of political rights and civil liberties around the world. It is composed of numerical ratings and supporting descriptive texts for 195 countries and 14 territories. Freedom in the World has been published since 1973, allowing Freedom House to track global trends in freedom over more than 40 years.

The raw data isn't easy to work with. This script downloads the data, arranges it in a tidy format, adds the continent of each country, and exports a `csv` in the new format. In the future I plan on documenting the process.