data {
  int <lower=0> N;
  int <lower=0> D;
  int<lower=0> S;
  int<lower=0> state[N];
  matrix[N, D] X;
  int <lower=0, upper=1> y[N];
} parameters {
  real alpha;
  vector[D] beta;
  vector[S] alpha_s;
  vector<lower=0>[S] sigma_s;
} model {
  alpha ~ normal(0, 5);
  beta ~ normal(0, 5);
  sigma_s ~ normal(0, 5);
  alpha_s ~ normal(alpha, sigma_s);
  y ~ bernoulli_logit(alpha_s[state] + X * beta);
} generated quantities {
  int<lower=0, upper=1> y_rep[N];
  vector[S] theta_s;
  for (i in 1:N){
   y_rep[i] = bernoulli_logit_rng(alpha_s[state[i]] + X[i, ] * beta); 
  }
  theta_s = inv_logit(alpha_s);
}
