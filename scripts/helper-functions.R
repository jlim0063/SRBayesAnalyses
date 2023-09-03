# Create z score for log RT
z_score <- function(x){
  z <- (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
  return(z)
}

# Function to compute Shannon entropy
calc_entropy <- function(prob_vector) {
  # Check if the input is a vector of length 2
  if ( length(prob_vector) != 2) {
    stop("Input must be a vector of length 2 containing probability values.")
  }
  
  # Check if the probabilities sum up to 1
  if (abs(sum(prob_vector) - 1) > 1e-8) {
    stop("Probabilities must sum up to 1.")
  }
  
  # Calculate Shannon's entropy
  H <- -sum(prob_vector * log2(prob_vector))
  return(H)
}
