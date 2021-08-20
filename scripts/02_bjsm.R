library(tidyverse)
library(rstan)
library(tidybayes)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

sim_df <- read_rds("../data/01_generated_data.rds")

responses_df <- sim_df %>%
  ungroup() %>%
  select(-treatment) %>%
  pivot_wider(names_from = "stage",
              values_from = "responder") %>%
  rename(
    response_1 = `1`,
    response_2 = `2`
  )

treatments_df <- sim_df %>%
  ungroup() %>%
  select(-responder) %>%
  pivot_wider(names_from = "stage",
              values_from = "treatment") %>%
  rename(
    treatment_1 = `1`,
    treatment_2 = `2`
  )

model_df <- inner_join(responses_df, treatments_df, by = "id")

model_df_stan <- compose_data(model_df)

mod <- stan_model("02_bjsm.stan")


fit <- sampling(mod, data = model_df_stan, iter = 4000)

traceplot(fit)
