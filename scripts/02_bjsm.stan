// The input data is a vector 'y' of length 'N'.
data {
  int<lower = 0> n;
  int<lower = 0, upper = 1> response_1[n];
  int<lower = 0, upper = 1> response_2[n];
  int<lower = 1, upper = 3> treatment_1[n];
  int<lower = 1, upper = 3> treatment_2[n];
  int n_treatment_1;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector<lower = 0, upper = 1>[n_treatment_1] pi;
  real<lower = 1> beta_1;
  real<lower = 0, upper = 1> beta_0;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  response_1 ~ bernoulli(pi[treatment_1]);
  
  for(i in 1:n)
    response_2[i] ~ bernoulli((beta_1 * pi[treatment_2[i]]) ^ response_1[i] * (beta_0 * pi[treatment_2[i]]) ^ (1 - response_1[i]));
  
  // priors
  pi ~ beta(0.6, 1.4);
  beta_0 ~ beta(1, 1);
  beta_1 ~ pareto(1, 3);
}
