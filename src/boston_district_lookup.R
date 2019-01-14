lookup <- tribble(
  ~DISTRICT, ~NAME,
  "A1", "Downtown",
  "A15", "Charlestown",
  "A7", "East Boston",
  "B2", "Roxbury",
  "B3", "Mattapan",
  "C6", "South Boston",
  "C11", "Dorchester",
  "D4", "South End",
  "D14", "Brighton",
  "E5", "West Roxbury",
  "E13", "Jamaica Plain",
  "E18", "Hyde Park"
)

tmp <- crime %>%
  left_join(lookup) %>%
  group_by(NAME, OFFENSE_CODE_GROUP) %>%
  filter(OFFENSE_CODE_GROUP == "Homicide") %>%
  count()


crime_groups <- as.tibble(unique(crime$OFFENSE_CODE_GROUP)) %>%
  rename(CRIME = 1) %>%
  arrange(CRIME)
