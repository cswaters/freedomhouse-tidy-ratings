library(readxl)
library(tidyverse)
library(countrycode)


fh_link <- 'https://freedomhouse.org/sites/default/files/Country%20and%20Territory%20Ratings%20and%20Statuses%20FIW1973-2018.xlsx'
download.file(fh_link,destfile = 'fhrankings.xlsx')
df <- read_excel('fhrankings.xlsx',sheet = 2)

tot_countries <- df[3:nrow(df),1] %>% nrow()
ranking_types <- 3
tot_cols <- (2017-1972) * ranking_types + 1 # should be columns

tmp <-
  matrix(ncol = tot_cols, nrow = tot_countries, byrow = TRUE) %>% as_tibble()

new_cols <-
  map(c(1972:1981, 1983:2017),  ~ paste0(c('pr_', 'cl_', 'status_'), .x)) %>%
  unlist()

new_cols <- c('country', new_cols)
names(tmp) <- new_cols
countries <- pull(df[3:nrow(df),1])

tmp$country <- countries
tmp[,-1] <- df[3:nrow(df),2:136]

tmp <- tmp %>% 
  map_df(~ifelse(.x=='-',NA,.x))


yr_desc <- df[1,] %>% 
  select(-contains('X__')) %>% 
  t() %>% 
  as.data.frame() %>% 
  rownames_to_column() %>% 
  set_names(c('SurveyEdition','YearsUnderReview')) %>% 
  slice(-1)


yr_desc$SurveyEdition <-
  str_replace_all(yr_desc$SurveyEdition, '-', ' to ') %>%
  str_remove_all('[.]')

yr_desc$YearsUnderReview <- str_replace_all(yr_desc$YearsUnderReview, '-', ' to ') %>% 
  str_replace_all('[.]',' ') %>% 
  str_replace_all('  ', ' ')
  
yr_desc$yr <- c(1972:1981,1983:2017)

fh_tidy <- tmp %>% 
  gather(key,rating,-country) %>% 
  separate(key, into = c('cat','yr')) %>% 
  mutate(yr = as.numeric(yr)) %>% 
  left_join(yr_desc)


fh_tidy <- fh_tidy %>% 
  spread(cat,rating,fill = NA)

fh_nested <- fh_tidy %>%
  group_by(country) %>%
  nest()

fh_nested$continent <-
  countrycode(
    sourcevar = fh_nested$country,
    origin = "country.name",
    destination = "continent"
  )

# fh_nested %>% 
#   filter(is.na(continent))

fh_nested[is.na(fh_nested$continent), 'continent'] <-
  c('Europe', 'Europe', 'Oceania', 'Europe', 'Europe')

fh_nested %>% 
  unnest(data) %>% 
  write_csv('freedom_house_ratings.rds')
