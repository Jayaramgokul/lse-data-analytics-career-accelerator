# 06. Exploratory analysis in R (R script, assignment 5).
#
# The sales team works in R, so the exploration was repeated there: band
# remuneration, spending and age into groups, summarise loyalty points by group
# and by product, and plot the distributions.
#
#   Rscript 06_r_exploration.R

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

raw <- read.csv("../data/turtle_reviews.csv", check.names = FALSE)
turtle <- raw %>%
  select(-language, -platform, -review, -summary) %>%
  rename(remuneration = `remuneration (k£)`, spending_score = `spending_score (1-100)`) %>%
  mutate(across(c(gender, education), as.factor),
         rem_band = cut(remuneration, c(-Inf, 31, 55, Inf), c("Low", "Middle", "High"), right = FALSE),
         age_category = cut(age, c(18, 32, 50, Inf), c("Young Adult", "Middle Aged", "Senior"),
                            right = FALSE, include.lowest = TRUE),
         spending_category = cut(spending_score, c(0, 40, 60, Inf), c("Low", "Medium", "High"),
                                 right = FALSE, include.lowest = TRUE))

cat(sprintf("%d customers, %d products, missing values: %d\n\n",
            nrow(turtle), n_distinct(turtle$product), sum(is.na(raw))))
cat(sprintf("Note: %d customers aged 17 fall below the first age band, which starts at 18.\n\n", sum(turtle$age < 18)))

cat("Median loyalty points by remuneration band and spending category:\n")
grid <- turtle %>%
  group_by(rem_band, spending_category) %>%
  summarise(customers = n(), median_loyalty = median(loyalty_points), .groups = "drop")
print(as.data.frame(grid), row.names = FALSE)

cat("\nProducts with the highest median loyalty points (at least 10 reviews):\n")
top <- turtle %>%
  group_by(product) %>%
  summarise(n = n(), med_loyalty = median(loyalty_points), .groups = "drop") %>%
  filter(n >= 10) %>%
  arrange(desc(med_loyalty)) %>%
  head(5)
print(as.data.frame(top), row.names = FALSE)

dir.create("output", showWarnings = FALSE)
p <- ggplot(turtle, aes(spending_score, loyalty_points, colour = rem_band)) +
  geom_point(alpha = 0.5, size = 1) +
  labs(x = "Spending score", y = "Loyalty points", colour = "Remuneration band",
       title = "Loyalty points rise with spending, most steeply for high earners") +
  theme_minimal(base_size = 10)
ggsave("output/06_r_loyalty_by_band.png", p, width = 7, height = 4, dpi = 150)
cat("\nChart: output/06_r_loyalty_by_band.png\n")

cat("\nWhat this shows: banding turns three continuous measures into groups the sales team can act on.\n",
    "Loyalty points climb with spending in every remuneration band, but the climb is steepest for high\n",
    "earners, an interaction a single straight line cannot capture.\n", sep = "")
