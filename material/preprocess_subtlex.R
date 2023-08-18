library(tidyverse)
material_dir <- "/Users/alejandracamelocruz/Desktop/endterm_project/attentional_blink/material"
subtlex <- read_tsv(file.path(material_dir, "SUBTLEX.txt"))

colors <- subtlex %>%
  filter(Word %in% c("blue", "red", "green", "yellow"))

adj <- subtlex %>%
  mutate(nltr = nchar(Word)) %>%
  filter(nltr >=3 & nltr<=6 &
           Dom_PoS_SUBTLEX == "Adjective" &
           Lg10WF>=2.8 & Lg10WF<= 4.0)

adj %>% pull(Word) %>% writeLines(file.path(material_dir, "target_adjectives_unclean.txt"))

# list needs to be cleaned manually. For example, all color terms have to be removed