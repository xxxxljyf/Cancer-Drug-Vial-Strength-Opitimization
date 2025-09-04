generate_possible_units <- function(unit) {
  possible_units <- c(unit * 0.5, unit * 0.75, unit, unit * 1.25, unit * 1.5)
  possible_units <- ifelse(possible_units > 5, round(possible_units / 5) * 5, possible_units)
  possible_units <- unique(possible_units)
  return(possible_units)
}

calculate_waste <- function(df, unit, base_price) {
  new_price <- (unit / unique(df$unit)) * base_price
  required_packs <- ceiling(df$demand / unit)
  waste_packs <- required_packs - (df$demand / unit)
  total_waste <- sum(waste_packs * new_price, na.rm = TRUE)
  return(total_waste)
}

optimize_for_each_drug <- function(df) {
  unit_values <- unique(df$unit)
  non_one_units <- unit_values[unit_values != 1]
  if (length(non_one_units) > 0) {
    original_unit <- non_one_units[1]
  } else {
    original_unit <- unit_values[1]
  }
  original_unit <- unit_values
  base_price <- median(df$price)
  drug_name <- unique(df$drugname)
  
  if (length(drug_name) != 1) {
    warning(paste("Drug", unique(df$drugid), "has multiple names:", paste(drug_name, collapse = ", ")))
    drug_name <- drug_name[1] 
  }
  
  original_waste <- calculate_waste(df, original_unit, base_price)
  
  possible_units <- generate_possible_units(original_unit)
  
  best_unit <- original_unit
  min_waste <- original_waste
  
  for (unit in possible_units) {
    current_waste <- calculate_waste(df, unit, base_price)
    if (!is.na(current_waste) && current_waste < min_waste) {
      min_waste <- current_waste
      best_unit <- unit
    }
  }
  
  reduction_percent <- if(original_waste < 1e-5) {
    0
  } else {
    max(0, (original_waste - min_waste) / original_waste * 100)
  }
  
  return(data.frame(
    drugid = unique(df$drugid),
    original_unit = original_unit,
    best_unit = best_unit,
    original_waste = original_waste,
    min_total_waste = min_waste,
    reduction_percent = reduction_percent,
    stringsAsFactors = FALSE
  ))
}

results <- data %>%
  group_by(drugid) %>%
  do(optimize_for_each_drug(.))
