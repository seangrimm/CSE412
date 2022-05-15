data <- read.csv('temporal_data.csv')

# fix (part of) HB 1000
data$democrat_sponsor_count[1] <- 22
data$republican_sponsor_count[1] <- 9

chapters <- rep(NA, nrow(data))
years <- rep(NA, nrow(data))

for (i in 1:nrow(data)) {
  # add partisan indicator
  if (data$democrat_sponsor_count[i] == 0) {
    data$party[i] <- 'republican'
  } else if (data$republican_sponsor_count[i] == 0) {
    data$party[i] <- 'democrat'
  } else {
    data$party[i] <- 'bipartisan'
  }
  
  if (data$after_passage_progress[i] == "['1', '1', '1', '1']") {
    # chapter_year
    cl_str <- strsplit(data$current_status[i], " ")
    chapters[i] <- as.integer(cl_str[[1]][2])
    years[i] <- as.integer(cl_str[[1]][4])
    
    # statuses
    data$general_status[i] <- 'passed'
  } else if (data$after_passage_progress[i] == "['1', '1', '1', '0']") {
    data$general_status[i] <- 'vetoed'
  } else if (substring(data$current_status[i], 2, 6) == 'Rules') {
    if (substring(data$current_status[i], nchar(data$current_status[i]) - 1) == ' X') {
      data$general_status[i] <- 'x-file'
    } else {
      data$general_status[i] <- 'rules committee'
    }
  } else {
    data$general_status[i] <- 'in committee'
  }
}

data$chapter <- chapters
data$year <- years

write.csv(data, file='')