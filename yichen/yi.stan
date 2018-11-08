data {
  int<lower=0> N;              // num individuals
  int<lower=1> K;              // num ind predictors
  int<lower=1> J;              // num groups
  int<lower=1> L;              // num group predictors
  int<lower=1,upper=J> jj[N];  // group for individual
  matrix[N, K] x;               // individual predictors
  matrix[L, J] u;          // group predictors
  vector[N] y;                 // outcomes
}
parameters {
  matrix[K, J] z;
  cholesky_factor_corr[K] L_Omega;
  vector<lower=0,upper=pi()/2>[K] tau_unif;
  matrix[L, K] gamma;                         // group coeffs
  real<lower=0> sigma;                       // prediction error scale
}
transformed parameters {
  matrix[J, K] beta;
  vector<lower=0>[K] tau;     // prior scale
  
  for (k in 1:K){
    tau[k] = 2.5 * tan(tau_unif[k]);
  } 
  beta =  (diag_pre_multiply(tau,L_Omega) * z)' + u * gamma;
}
model {
  to_vector(z) ~ std_normal();
  L_Omega ~ lkj_corr_cholesky(2);
  to_vector(gamma) ~ normal(0, 5);
  y ~ normal(rows_dot_product(beta[jj] , x), sigma);
}
generated quantities {
  vector[N] y_rep;
  for (n in 1:N){
    y_rep[n] = normal_rng(rows_dot_product(beta[jj] , x), sigma);
  }
}
