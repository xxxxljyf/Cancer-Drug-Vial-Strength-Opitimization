# Cancer-Drug-Vial-Strength-Opitimization

This repository contains an R implementation of a discrete optimization model that reduces cancer drug wastage by optimizing vial strength. The model is designed with **clinically feasible constraints** and aligns with **manufacturing and clinical practice standards**.  

## Model Overview
- **Objective:** Minimize financial and volume wastage of cancer drugs.  
- **Constraints:** Candidate strengths are limited to 0.5×, 0.75×, 1×, 1.25×, and 1.5× of the original vial strength.  
- **Manufacturing Rule:** All optimized strengths above 5 units are rounded to the nearest multiple of 5.  
- **Output:** For each drug, the algorithm returns the original strength, optimal strength, waste reduction, and percentage improvement.  

## Code Structure
- `generate_possible_units()`: Generates feasible strength options given an original strength.  
- `calculate_waste()`: Computes total financial waste for a given strength.  
- `optimize_for_each_drug()`: Iterates through possible strengths, selecting the one that minimizes wastage.  
- Final results are summarized by drug ID in a structured data frame.  

## Example Usage
```R
# Load libraries
library(dplyr)

# Example dataset
data <- data.frame(
  drugid   = c(1, 1, 1, 2, 2),
  drugname = c("DrugA", "DrugA", "DrugA", "DrugB", "DrugB"),
  unit     = c(100, 100, 100, 50, 50),
  demand   = c(230, 150, 80, 120, 200),
  price    = c(1000, 1000, 1000, 500, 500)
)

# Run optimization
results <- data %>%
  group_by(drugid) %>%
  do(optimize_for_each_drug(.))

print(results)
```
## Example Output

| drugid | original_unit | best_unit | original_waste | min_total_waste | reduction_percent |
|--------|---------------|-----------|----------------|-----------------|-------------------|
| 1      | 100           | 75        | 2500           | 1800            | 28.0              |
| 2      | 50            | 50        | 900            | 900             | 0.0               |

*(Values are illustrative; actual results depend on input dataset.)*
