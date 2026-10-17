## LSE Data Analytics Online Career Accelerator 
# DA301:  Advanced Analytics for Organisational Impact

###############################################################################

# Assignment 5 scenario
## Turtle Games’s sales department has historically preferred to use R when performing 
## sales analyses due to existing workflow systems. As you’re able to perform data analysis 
## in R, you will perform exploratory data analysis and present your findings by utilising 
## basic statistics and plots. You'll explore and prepare the data set to analyse sales per 
## product. The sales department is hoping to use the findings of this exploratory analysis 
## to inform changes and improvements in the team. (Note that you will use basic summary 
## statistics in Module 5 and will continue to go into more detail with descriptive 
## statistics in Module 6.)

################################################################################

## Assignment 5 objective
## Load and wrangle the data. Use summary statistics and groupings if required to sense-check
## and gain insights into the data. Make sure to use different visualisations such as scatterplots, 
## histograms, and boxplots to learn more about the data set. Explore the data and comment on the 
## insights gained from your exploratory data analysis. For example, outliers, missing values, 
## and distribution of data. Also make sure to comment on initial patterns and distributions or 
## behaviour that may be of interest to the business.

################################################################################

# Module 5 assignment: Load, clean and wrangle data using R

## It is strongly advised that you use the cleaned version of the data set that you created and 
##  saved in the Python section of the course. Should you choose to redo the data cleaning in R, 
##  make sure to apply the same transformations as you will have to potentially compare the results.
##  (Note: Manual steps included dropping and renaming the columns as per the instructions in module 1.
##  Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 

## 1. Open your RStudio and start setting up your R environment. 
## 2. Open a new R script and import the turtle_review.csv data file, which you can download from 
##      Assignment: Predicting future outcomes. (Note: You can use the clean version of the data 
##      you saved as csv in module 1, or, can manually drop and rename the columns as per the instructions 
##      in module 1. Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 
## 3. Import all the required libraries for the analysis and view the data. 
## 4. Load and explore the data.
##    - View the head the data.
##    - Create a summary of the new data frame.
## 5. Perform exploratory data analysis by creating tables and visualisations to better understand 
##      groupings and different perspectives into customer behaviour and specifically how loyalty 
##      points are accumulated. Example questions could include:
##    - Can you comment on distributions, patterns or outliers based on the visual exploration of the data?
##    - Are there any insights based on the basic observations that may require further investigation?
##    - Are there any groupings that may be useful in gaining deeper insights into customer behaviour?
##    - Are there any specific patterns that you want to investigate
## 6. Create
##    - Create scatterplots, histograms, and boxplots to visually explore the loyalty_points data.
##    - Select appropriate visualisations to communicate relevant findings and insights to the business.
## 7. Note your observations and recommendations to the technical and business users.

###############################################################################

# Your code here.




############################
# Setting up the work environment and directory where I have the files placed
############################

setwd('~/Library/Mobile\ Documents/com~apple~CloudDocs/Desktop/LSE Files/LSE_DA301_Module_5_files/Data')


############################
# 1) Libraries
############################

install.packages("tidyverse")
install.packages("skimr")
install.packages("DataExplorer")
install.packages("moments")
install.packages("car")
install.packages("lmtest")
install.packages("Metrics")



library(tidyverse)
library(skimr)
library(DataExplorer)
library(moments)
library(broom)
library(car)
library(lmtest)
library(Metrics)


############################
# 2) Loading Data & Basic Exploration
############################

# 2.1 Loading our cleaned turtle file from previous python project
turtle <- read_csv("turtle_reviews_cleaned.csv")

# 2.2 Data Inspection
skim(turtle)          # Personally prefer to start by inspecting the overall structure of the numerical and categorical variables
summary(turtle)       # Then the overall summary of the turtle data
DataExplorer::create_report(turtle) # Created the data explorer report just to get a quick overview of the data that we have

# 2.3 Checking for Duplicate rows
nrow(turtle)
nrow(distinct(turtle))

############################
# 3) Additional Data tidying for R exploration 
############################

# 3.1 Dropping the review and summary columns from the dataset - we are only working with non text data
turtle_clean <- turtle %>%
  select("gender","age","remuneration","spending_score","loyalty_points","education","product")

# 3.2 Making character like variables into categorical variables
turtle_clean$product <- as.factor(turtle_clean$product)
turtle_clean$gender <- as.factor(turtle_clean$gender)
turtle_clean$education <- as.factor(turtle_clean$education)

# 3.3 Checking Data Types again
skim(turtle_clean) 

############################
# 4) Data Quality Checks to ensure accuracy
############################

# 4.1 Checking for Missing values
sum(is.na(turtle_clean))


## INFERENCE ----> The data has no missing values and has no duplicates either ! ##
                                                         

############################
# 5) Feature Engineering
############################

# 5.1 Creating new bands of remuneration, spending_score & age to visualize interesting groupings
  turtle_clean <- turtle_clean %>%
    mutate(
      rem_band = cut(
        remuneration,
        breaks = c(-Inf, 31, 55, Inf),
        labels = c("Low", "Middle", "High"),
        right = FALSE
      ),
      age_category = cut(
        age,
        breaks = c(18, 32, 50, Inf),
        labels = c("Young Adult", "Middle Aged", "Senior"),
        right = FALSE,
        include.lowest = TRUE
      ),
      spending_category = cut(
        spending_score,
        breaks = c(0, 40, 60, Inf),
        labels = c("Low", "Medium", "High"),
        right = FALSE,
        include.lowest = TRUE
      )
    )
  


############################
# 6) Grouping summaries and other descriptive stats
############################


# 6.1 Product by Loyalty Points Group Summary

  prod_summary_loyalty <- turtle_clean %>%
    group_by(product) %>%
    summarise(
      n = n(),
      med_loyalty = median(loyalty_points, na.rm = TRUE),
      p25_loyalty = quantile(loyalty_points, 0.25, na.rm = TRUE),
      p75_loyalty = quantile(loyalty_points, 0.75, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(n))

# 6.2 Product by Spending Score Summary

  prod_summary_spending <- turtle_clean %>%
    group_by(product) %>%
    summarise(
      n = n(),
      med_spending = median(spending_score, na.rm = TRUE),
      p25_spending = quantile(spending_score, 0.25, na.rm = TRUE),
      p75_spending = quantile(spending_score, 0.75, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(n))


############################
# 7) Visual EDA (Univariate + Bivariate)
############################

  
# 7.1 Loyalty points plots
  
  #Loyalty Points Distribution
  ggplot(turtle_clean, aes(x = loyalty_points)) +
    geom_histogram(bins = 30) +
    labs(title = "Distribution of Loyalty Points", x = "loyalty_points", y = "Count")
  ggsave("hist_loyalty_points.png", width = 8, height = 5)
  
  ggplot(turtle_clean, aes(y = loyalty_points)) +
    geom_boxplot() +
    labs(title = "Boxplot of Loyalty Points", y = "loyalty_points")
  ggsave("box_loyalty_points.png", width = 6, height = 5)

# 7.2 Spending score plots

  # Spending score Distribution
  ggplot(turtle_clean, aes(x = spending_score)) +
    geom_histogram(bins = 30) +
    labs(title = "Distribution of Spending Score", x = "spending_score", y = "Count")
  ggsave("hist_spending_score.png", width = 8, height = 5)
  
  ggplot(turtle_clean, aes(x = spending_score)) +
    geom_density() +
    labs(title = "Density of Spending Score", x = "spending_score", y = "Density")
  ggsave("density_spending_score.png", width = 8, height = 5)
  
  ggplot(turtle_clean, aes(y = loyalty_points)) +
    geom_boxplot() +
    labs(
      title = "Boxplot of Loyalty Points",
      y = "loyalty_points"
    )
  
 
# 7.3 Remuneration plots

  # Remuneration Distribution
  ggplot(turtle_clean, aes(x = remuneration)) +
    geom_histogram(bins = 30) +
    labs(title = "Distribution of Remuneration", x = "remuneration", y = "Count")
  ggsave("hist_remuneration.png", width = 8, height = 5)
  
  ggplot(turtle_clean, aes(x = remuneration)) +
    geom_density() +
    labs(title = "Density of Remuneration", x = "remuneration", y = "Density")
  ggsave("density_remuneration.png", width = 8, height = 5)
  
  
 
  
# 7.4 Relationships between variables
  
  #  Remuneration vs Spending Score
  ggplot(turtle_clean, aes(x = spending_score, y = remuneration)) +
    geom_point(alpha = 0.5) +
    labs(title = "Remuneration vs Spending Score", x = "Spending score", y = "Remuneration")
  ggsave("scatter_remuneration_vs_spending.png", width = 8, height = 5)
  
  # Remuneration vs Loyalty Points
  ggplot(turtle_clean, aes(x = loyalty_points, y = remuneration)) +
    geom_point(alpha = 0.5) +
    labs(title = "Remuneration vs Loyalty Points", x = "Spending score", y = "Remuneration")
  ggsave("scatter_Remuneration_vs_Loyalty.png", width = 8, height = 5)
  
  # Spending score vs Loyalty points
  ggplot(turtle_clean, aes(x = spending_score, y = loyalty_points)) +
    geom_point(alpha = 0.5) +
    labs(title = "Spending Score vs Loyalty Points", x = "Spending score", y = "Loyalty points")
  ggsave("scatter_spending_vs_loyalty.png", width = 8, height = 5)
  
  # Loyalty Points by Education Distribution
  ggplot(turtle_clean, aes(x = education, y = loyalty_points)) +
    geom_boxplot() +
    labs(title = "Loyalty Points by Education", x = "Education", y = "Loyalty Points") 
  ggsave("box_loyalty_by_education.png", width = 9, height = 5)

  # Loyalty Points by Gender Distribution
  ggplot(turtle_clean, aes(x = gender, y = loyalty_points)) +
    geom_boxplot() +
    labs(title = "Loyalty Points by Gender", x = "Gender", y = "Loyalty Points") 
  ggsave("box_loyalty_by_gender.png", width = 7, height = 5)

  # Spending Score by Remuneration Band Distribution
  ggplot(turtle_clean, aes(x = rem_band, y = spending_score)) +
    geom_boxplot() +
    labs(title = "Spending Score by Remuneration Band", x = "Remuneration band", y = "Spending score") 
  ggsave("box_spending_by_rem_band.png", width = 8, height = 5)


# 7.5 Top/bottom products

  top10_loyalty_by_med <- prod_summary_loyalty %>%
    filter(n >= 5) %>%
    slice_max(med_loyalty, n = 10)
  
  bottom10_loyalty_by_med <- prod_summary_loyalty %>%
    filter(n >= 5) %>%
    slice_min(med_loyalty, n = 10)
  
# 7.6 Plots of top/bottom products
  ggplot(top10_loyalty_by_med,
         aes(x = reorder(product, med_loyalty), y = med_loyalty)) +
    geom_errorbar(aes(ymin = p25_loyalty, ymax = p75_loyalty), width = 0.2) +
    geom_point(size = 2) +
    coord_flip() +
    labs(title = "Top 10 products by median loyalty points",
         x = "Product", y = "Median loyalty points (25–75% range)") +
    theme_minimal()
  ggsave("top10_products_loyalty.png", width = 9, height = 6)
  
  ggplot(bottom10_loyalty_by_med,
         aes(x = reorder(product, med_loyalty), y = med_loyalty)) +
    geom_errorbar(aes(ymin = p25_loyalty, ymax = p75_loyalty), width = 0.2) +
    geom_point(size = 2) +
    coord_flip() +
    labs(title = "Bottom 10 products by median loyalty points",
         x = "Product", y = "Median loyalty points (25–75% range)") +
    theme_minimal()
  ggsave("bottom10_products_loyalty.png", width = 9, height = 6)


###############################################################################
###############################################################################

# Assignment 6 scenario

## In Module 5, you were requested to redo components of the analysis using Turtle Games’s preferred 
## language, R, in order to make it easier for them to implement your analysis internally. As a final 
## task the team asked you to perform a statistical analysis and create a multiple linear regression 
## model using R to predict loyalty points using the available features in a multiple linear model. 
## They did not prescribe which features to use and you can therefore use insights from previous modules 
## as well as your statistical analysis to make recommendations regarding suitability of this model type,
## the specifics of the model you created and alternative solutions. As a final task they also requested 
## your observations and recommendations regarding the current loyalty programme and how this could be 
## improved. 

################################################################################

## Assignment 6 objective
## You need to investigate customer behaviour and the effectiveness of the current loyalty program based 
## on the work completed in modules 1-5 as well as the statistical analysis and modelling efforts of module 6.
##  - Can we predict loyalty points given the existing features using a relatively simple MLR model?
##  - Do you have confidence in the model results (Goodness of fit evaluation)
##  - Where should the business focus their marketing efforts?
##  - How could the loyalty program be improved?
##  - How could the analysis be improved?

################################################################################

## Assignment 6 assignment: Making recommendations to the business.

## 1. Continue with your R script in RStudio from Assignment Activity 5: Cleaning, manipulating, and 
##     visualising the data.
## 2. Load and explore the data, and continue to use the data frame you prepared in Module 5.
## 3. Perform a statistical analysis and comment on the descriptive statistics in the context of the 
##     review of how customers accumulate loyalty points.
##  - Comment on distributions and patterns observed in the data.
##  - Determine and justify the features to be used in a multiple linear regression model and potential
##.    concerns and corrective actions.
## 4. Create a Multiple linear regression model using your selected (numeric) features.
##  - Evaluate the goodness of fit and interpret the model summary statistics.
##  - Create a visual demonstration of the model
##  - Comment on the usefulness of the model, potential improvements and alternate suggestions that could 
##     be considered.
##  - Demonstrate how the model could be used to predict given specific scenarios. (You can create your own 
##     scenarios).
## 5. Perform exploratory data analysis by using statistical analysis methods and comment on the descriptive 
##     statistics in the context of the review of how customers accumulate loyalty points.
## 6. Document your observations, interpretations, and suggestions based on each of the models created in 
##     your notebook. (This will serve as input to your summary and final submission at the end of the course.)

################################################################################

# Your code here.

############################
# 1) Descriptive & Statistical Checks 
############################

# 1.1 Correlation matrix for numeric predictors 
num_df <- turtle_clean %>% select('age','remuneration','spending_score','loyalty_points')
corr_mat <- cor(num_df, use = "pairwise.complete.obs")
corr_mat_round <- round(corr_mat, 2)


# 1.2 Normality checks 
qqnorm(turtle_clean$loyalty_points); qqline(turtle_clean$loyalty_points, col = "red")
shapiro.test(turtle_clean$loyalty_points) 
skewness(turtle_clean$loyalty_points, na.rm = TRUE)
kurtosis(turtle_clean$loyalty_points, na.rm = TRUE)


############################
# 2) Build Multiple Linear Regression (MLR)
############################

# 2.1 Choose candidate predictors

candidate_numeric <- turtle_clean %>% select('age','remuneration','spending_score')
candidate_numeric

# 2.2 Define a formula

model_formula <- as.formula("loyalty_points ~ spending_score +  remuneration + age") 

# 2.3 Train/test split (simple evaluation)
set.seed(42)
n <- nrow(turtle_clean)
idx <- sample.int(n, size = floor(0.8 * n))
train <- turtle_clean[idx, ]
test <- turtle_clean[-idx, ]

# Fit model
mlr_model <- lm(model_formula, data = train)

# Model summary (coefficients + p-values + R^2)
summary(mlr_model)

# ANOVA table
anova(mlr_model)

# 2.4 Evaluate on test set (predictive performance)
pred_test <- predict(mlr_model, newdata = test)

# Metrics (lower is better for RMSE/MAE)
rmse(test$loyalty_points, pred_test)
mae(test$loyalty_points, pred_test)

# Save a simple actual vs predicted CSV for your report
eval_df <- tibble(
  actual = test$loyalty_points,
  predicted = pred_test,
  error = actual - predicted
)
write.csv(eval_df, "test_predictions.csv", row.names = FALSE)

# Visual: Actual vs Predicted
ggplot(eval_df, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1) +
  labs(title = "Actual vs Predicted Loyalty Points (Test Set)",
       x = "Actual", y = "Predicted")
ggsave("actual_vs_predicted.png", width = 8, height = 5)


############################
# 3) Goodness-of-fit + Diagnostics
############################

# 3.1 Residual plots (base R gives the standard 4)
png("lm_diagnostics.png", width = 1000, height = 900)
par(mfrow = c(2, 2))
plot(mlr_model)
dev.off()

# 3.2 Residual normality (this is about inference reliability)
res <- residuals(mlr_model)
qqnorm(res); qqline(res, col = "red")
shapiro.test(res)
skewness(res, na.rm = TRUE)
kurtosis(res, na.rm = TRUE)

# 3.3 Heteroskedasticity (Breusch–Pagan)
bptest(mlr_model)

# 3.4 Multicollinearity (VIF) — only meaningful when you have >1 predictor
# If you used factors, VIF can still work but interpretation needs care.
vif(mlr_model)

# 3.5 Influential points (Cook’s distance)
cooks <- cooks.distance(mlr_model)
plot(cooks, type = "h", main = "Cook's distance", ylab = "Cook's D")
abline(h = 4 / nrow(train), col = "red", lty = 2)
ggsave("cooks_distance.png", width = 8, height = 4)

# 3.6 Component Residual plots

# Re-use residuals from baseline model
res <- residuals(mlr_model)

# Residuals vs continuous predictors (with LOWESS smooth)
png("resid_vs_spending_score.png", width = 900, height = 600)
plot(train$spending_score, res, pch = 16, cex = 0.6,
     xlab = "spending_score", ylab = "Residuals",
     main = "Residuals vs spending_score (Baseline MLR)")
abline(h = 0, lty = 2)
lines(lowess(train$spending_score, res), lwd = 2)


png("resid_vs_remuneration.png", width = 900, height = 600)
plot(train$remuneration, res, pch = 16, cex = 0.6,
     xlab = "remuneration", ylab = "Residuals",
     main = "Residuals vs remuneration (Baseline MLR)")
abline(h = 0, lty = 2)
lines(lowess(train$remuneration, res), lwd = 2)


png("resid_vs_age.png", width = 900, height = 600)
plot(train$age, res, pch = 16, cex = 0.6,
     xlab = "age", ylab = "Residuals",
     main = "Residuals vs age (Baseline MLR)")
abline(h = 0, lty = 2)
lines(lowess(train$age, res), lwd = 2)


# Residuals vs categorical predictors (boxplots)

png("resid_by_gender.png", width = 900, height = 600)
boxplot(res ~ train$gender,
        xlab = "gender", ylab = "Residuals",
        main = "Residuals by gender (Baseline MLR)")
abline(h = 0, lty = 2)


png("resid_by_education.png", width = 1000, height = 600)
boxplot(res ~ train$education,
        xlab = "education", ylab = "Residuals",
        main = "Residuals by education (Baseline MLR)")
abline(h = 0, lty = 2)
dev.off()


# Component + residual plots (partial residual plots)
# These are especially helpful to detect non-linearity per predictor.
png("component_residual_plots_base.png", width = 1200, height = 800)


############################
# 4) Alternative Models 
############################

############################
# 4.A The age squared model
############################

# 4.A.1 Add non-linearity using squared of age that we inferred
mlr_model_age_squared<- lm(
  loyalty_points ~ spending_score + remuneration + age + I(age^2),
  data = train
)

# 4.A.2 Model summary (coefficients + p-values + R^2)
summary(mlr_model_age_squared)

# 4.A.3 ANOVA table
anova(mlr_model_age_squared)

# 4.A.4 RMSE & MAE
pred_age_squared <- predict(mlr_model_age_squared, newdata = test)
rmse_age_squared <- rmse(test$loyalty_points, pred_age_squared)
mae_age_squared <- mae(test$loyalty_points, pred_age_squared)
rmse_age_squared ; mae_age_squared

# 4.A.5  Actual vs predicted csv file
eval_df <- tibble(
  actual = test$loyalty_points,
  predicted = pred_age_squared,
  error = actual - predicted
)
write.csv(eval_df, "test_predictions.csv", row.names = FALSE)

# 4.A.6 Actual vs Predicted graphical plot
ggplot(eval_df, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1) +
  labs(title = "Actual vs Predicted Loyalty Points (Test Set)",
       x = "Actual", y = "Predicted")
ggsave("actual_vs_predicted.png", width = 7, height = 6)

# 4.A.7 Diagnostics
png("lm_diagnostics_mlr_model_age_squared.png", width = 1000, height = 900)
par(mfrow = c(2, 2))
plot(mlr_model_age_squared)
dev.off()

res_age_squared <- residuals(mlr_model_age_squared)
qqnorm(res_age_squared); qqline(res_age_squared, col = "red")
shapiro.test(res_age_squared)

bptest(mlr_model_age_squared)

vif(mlr_model_age_squared)

# 4.A.8 Influential points (Cook’s distance)
cooks <- cooks.distance(mlr_model_age_squared)
plot(cooks, type = "h", main = "Cook's distance", ylab = "Cook's D")
abline(h = 4 / nrow(train), col = "red", lty = 2)
ggsave("cooks_distance.png", width = 8, height = 4)



############################
# 4.B The age, remuneration & spending score squared model
############################

# 4.B.1 Add non-linearity using squared of age, remuneration & spending score that we inferred

mlr_model_quad_more <- lm(
  loyalty_points ~ spending_score + I(spending_score^2) +
    remuneration + I(remuneration^2) +
    age + I(age^2),
  data = train
)

# 4.B.2 Model summary (coefficients + p-values + R^2)
summary(mlr_model_quad_more)

# 4.B.3 ANOVA table
anova(mlr_model_quad_more)

# 4.B.4 RMSE & MAE
pred_quad_more <- predict(mlr_model_quad_more, newdata = test)

rmse_quad_more <- rmse(test$loyalty_points, pred_quad_more)
mae_quad_more  <- mae(test$loyalty_points, pred_quad_more)

rmse_quad_more; mae_quad_more

# 4.B.5 Save a simple actual vs predicted CSV for your report
eval_df_quad_more <- tibble(
  actual = test$loyalty_points,
  predicted = pred_quad_more,
  error = actual - predicted
)
write.csv(eval_df_quad_more, "test_predictions_quad_more.csv", row.names = FALSE)

# 4.B.6 Actual vs Predicted
ggplot(eval_df_quad_more, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1) +
  labs(title = "Actual vs Predicted Loyalty Points (Quad terms added, Test Set)",
       x = "Actual", y = "Predicted")
ggsave("actual_vs_predicted_quad_more.png", width = 8, height = 5)

# 4.B.7 Diagnostics
png("lm_diagnostics_mlr_model_quad_more.png", width = 1000, height = 900)
par(mfrow = c(2, 2))
plot(mlr_model_quad_more)


res_quad_more <- residuals(mlr_model_quad_more)
qqnorm(res_quad_more); qqline(res_quad_more, col = "red")
shapiro.test(res_quad_more)

bptest(mlr_model_quad_more)

vif(mlr_model_quad_more)

# 4.B.8 Cook's distance
cooks <- cooks.distance(mlr_model_quad_more)
plot(cooks, type = "h", main = "Cook's distance (Quad terms added)", ylab = "Cook's D")
abline(h = 4 / nrow(train), col = "red", lty = 2)
ggsave("cooks_distance_quad_more.png", width = 8, height = 4)

############################
# 5.C The log(loyalty points) model
############################

# 5.C.1 Converting loyalty points to log version & fitting model

mlr_model_log <- lm(
  log1p(loyalty_points) ~ spending_score + remuneration + age,
  data = train
)

# 5.C.2 Model summary (coefficients + p-values + R^2)
summary(mlr_model_log)

# 5.C.3 ANOVA table
anova(mlr_model_log)

# 5.C.4 RMSE/MAE
pred_log <- predict(mlr_model_log, newdata = test)
pred_log_back <- expm1(pred_log) # ensures > -1 mathematically; tends to reduce negatives

rmse_log <- rmse(test$loyalty_points, pred_log_back)
mae_log <- mae(test$loyalty_points, pred_log_back)

rmse_log; mae_log


# 5.C.5 Save a simple actual vs predicted CSV for your report
eval_df <- tibble(
  actual = test$loyalty_points,
  predicted = pred_log_back,
  error = actual - predicted
)
write.csv(eval_df, "test_predictions.csv", row.names = FALSE)

# 5.D.6 Visual: Actual vs Predicted
ggplot(eval_df, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1) +
  labs(title = "Actual vs Predicted Loyalty Points (Test Set)",
       x = "Actual", y = "Predicted")
ggsave("actual_vs_predicted.png", width = 8, height = 5)

# 5.D.7 Diagnostics for log model
png("lm_diagnostics_mlr_model_log.png", width = 1000, height = 900)
par(mfrow = c(2, 2))
plot(mlr_model_log)


res_log <- residuals(mlr_model_log)
qqnorm(res_log); qqline(res_log, col = "red")
shapiro.test(res_log)

# Check heteroskedasticity on log scale (more meaningful for this model)
bptest(mlr_model_log)

vif(mlr_model_log)

# 5.D.8 Influential points (Cook’s distance)
cooks <- cooks.distance(mlr_model_log)
plot(cooks, type = "h", main = "Cook's distance", ylab = "Cook's D")
abline(h = 4 / nrow(train), col = "red", lty = 2)
ggsave("cooks_distance.png", width = 8, height = 4)


############################################################
# 6) Compare models side-by-side (simple scoreboard)
############################################################
# 6.1 Predictions on test set (all evaluated on loyalty_points scale)

# Baseline MLR
pred_base <- predict(mlr_model, newdata = test)
rmse_base <- rmse(test$loyalty_points, pred_base)
mae_base  <- mae(test$loyalty_points, pred_base)

# Age-squared MLR
pred_age2 <- predict(mlr_model_age_squared, newdata = test)
rmse_age2 <- rmse(test$loyalty_points, pred_age2)
mae_age2  <- mae(test$loyalty_points, pred_age2)

# Quadratic-more MLR
pred_quad_more <- predict(mlr_model_quad_more, newdata = test)
rmse_quad_more <- rmse(test$loyalty_points, pred_quad_more)
mae_quad_more  <- mae(test$loyalty_points, pred_quad_more)

# Log1p(target) MLR (back-transform predictions)
pred_log <- predict(mlr_model_log, newdata = test)
pred_log_back <- expm1(pred_log)

rmse_log <- rmse(test$loyalty_points, pred_log_back)
mae_log  <- mae(test$loyalty_points, pred_log_back)

# 6.2 Scoreboard table
scoreboard <- tibble(
  model = c(
    "Baseline MLR: loyalty ~ spending + remuneration + age",
    "MLR + age^2",
    "MLR + (spending^2, remuneration^2, age^2)",
    "Log1p(loyalty) MLR (back-transformed)"
  ),
  rmse = c(rmse_base, rmse_age2, rmse_quad_more, rmse_log),
  mae  = c(mae_base,  mae_age2,  mae_quad_more,  mae_log)
) %>%
  arrange(rmse)

scoreboard
write.csv(scoreboard, "model_scoreboard.csv", row.names = FALSE)

############################
# 7) Scenario Predictions (Demonstrate model usage)
############################


scenario_df <- tibble(
  spending_score = c(30, 55, 75),
  remuneration   = c(20, 40, 70),
  age            = c(25, 40, 60)
)

scenario_df$pred_loyalty_points <- predict(mlr_model, newdata = scenario_df)
scenario_df
write.csv(scenario_df, "scenario_predictions.csv", row.names = FALSE)


############################
# 8) Final Summary (150–200 words) 
############################
"
The turtle games dataset was analysed to understand how the loyalty_points variable can be modelled using the other closely associated variables 
like spending_score, remuneration & age which we analysed in the previous section (Exploratory Data Analysis & Correlation Plots)
We used MLR models to understand the fit and predictive power and used inferential statistical tests & diagnostics to confirm our understanding.

A baseline MLR using spending_score, remuneration, and age is considered an interpretable, simple model, however its diagnostics
(component residual plots) reveal that a straight line model may miss the underlying pattern of the data.Consequently this reflects in their component 
residual plots, when examined, showing how the age variable, along with the other variables to a lesser extent, showed residual structure. 
All the other diagnostic checks (Shapiro test, Breusch–Pagan test, VIF, and Cook’s distance) also imply that the baseline linear form may not fully 
capture the data structure, particularly due to skewness and potential non-constant variance. 

Given this, we further considered iterations of possible models including age² and all predictor squared model as well as log transform on the target variable(loyalty_points), as candidates, and compared all of their performance metrics using RMSE and MAE. 
The squared models performed better than the baseline model against all performance metrics including RMSE & MAE.The goodnes of fit test also indicated a better variance explanation by the squared models. 
The log transform on the target variable (loyalty_points), however reduced the performance metrics and fit.

Thus the squared model can be used to predict how loyalty points should accumulate for various customers based on the MLR model, using spending score and remuneration as inputs. 
Yet it is noted that none of these models fully does away with the heteroskedasticity or the residual structure that we observed. More importantly the MLR model doesnt assure us non negative values for loyalty_points,
meaning the modelled results cannot be relied on.

Thus we need to explore higher order models including non linear ones to help getter performance and diagnostics from the model.
"
###############################################################################
###############################################################################




