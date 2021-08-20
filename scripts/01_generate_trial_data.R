library(tidyverse)

set.seed(89234)

sim_df <- expand_grid(
  id = seq(1, 50),
  stage = c(1, 2)
) %>%
  group_by(id) %>%
  mutate(
    treatment = if_else(stage == 1, sample(x = c("A", "B", "C"), size = 1), NA_character_),
    responder = case_when(
      treatment == "C" ~ rbinom(1, 1, 0.3),
      treatment == "B" ~ rbinom(1, 1, 0.2),
      treatment == "A" ~ rbinom(1, 1, 0.1)
    ),
    treatment = if_else(first(responder) == 1 & stage == 2, first(treatment), if_else(stage == 2 & first(treatment) == "A", sample(c("B", "C"), 1), 
                                                                                      if_else(stage == 2 & first(treatment) == "B", sample(c("A", "C"), 1), 
                                                                                              if_else(stage == 2 & first(treatment) == "C", sample(c("A", "B"), 1), treatment)))),
    responder = case_when(
      stage == 2 & treatment == "A" & first(treatment) == "A" ~ rbinom(1, 1, 1.5 * 0.1),
      stage == 2 & treatment == "B" & first(treatment) == "B" ~ rbinom(1, 1, 1.5 * 0.2),
      stage == 2 & treatment == "C" & first(treatment) == "C" ~ rbinom(1, 1, 1.5 * 0.3),
      stage == 2 & treatment == "A" & first(treatment) != "A" ~ rbinom(1, 1, 0.5 * 0.1),
      stage == 2 & treatment == "B" & first(treatment) != "B" ~ rbinom(1, 1, 0.5 * 0.2),
      stage == 2 & treatment == "C" & first(treatment) != "C" ~ rbinom(1, 1, 0.5 * 0.3),
      stage == 1 ~ responder
    )
  )

write_rds(sim_df, "../data/01_generated_data.rds")
