---
title: "Irene Hsueh's BS 806 Homework 4"
author: "Irene Hsueh"
date: "10/1/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(emmeans)
```

### Reading in CSV File
```{r}
depression <- read.csv("C:/Irene Hsueh's Documents/MS Applied Biostatistics/BS 806 - Multivariate Analysis for Biostatisticians/Class 4 - Dummy Variables and ANCOVA/Homework 4/depress2.csv")
```



### Preparation
```{r}
#Summary Statistics Stratified by Public Assistance Status
head(depression)
by(data=depression, depression$publicassist, summary)

#Visual Inspection 
par(mfrow=c(1,2))
boxplot(cesd ~ publicassist, data=depression, col=c("hotpink", "cyan2"))
plot(cesd ~ age, data=depression, col=c("hotpink", "cyan2"))
```



### Two-Sample Two-Tailed T-Test
```{r}
t.test(cesd ~ publicassist, data=depression)
```



### Multiple Linear Regression
```{r}
linear_model <- lm(cesd ~ age + publicassist, data=depression)
summary(linear_model)

#Test Effect of publicassistance
no_publicassist <- lm(cesd ~ age, data=depression)
anova(no_publicassist, linear_model)
anova(no_publicassist, linear_model)$F
anova(no_publicassist, linear_model)$P

#Test Effect of age
no_age <- lm(cesd ~ publicassist, data=depression)
anova(no_age, linear_model)
anova(no_age, linear_model)$F
anova(no_age, linear_model)$P
```



### Generating Plots
```{r}
#No Public Assistance
no_assist_intercept <- linear_model$coefficients[1]
no_assist_beta <- linear_model$coefficients[2]

#Public Assistance
assist_intercept <- linear_model$coefficients[1] + linear_model$coefficients[3]
assist_beta <- linear_model$coefficients[2]

#Plot
plot(cesd ~ age, data=depression, col=c("hotpink", "cyan2"))
abline(no_assist_intercept, assist_beta) #No Public Assistance
abline(assist_intercept, assist_beta, lty=2) #Public Assistance

#Predicting CESD value
assist_intercept+assist_beta*14

#95% Confidence Intervals
confint(linear_model)
```



### Least Square Means 
```{r}
emmeans(linear_model, pairwise~publicassist)

#No Public Assistance 
lsm_no_assist <- linear_model$coefficients[1] + linear_model$coefficients[2]*mean(depression$age)
lsm_no_assist

#Public Assistance
lsm_assist <- linear_model$coefficients[1] + linear_model$coefficients[2]*mean(depression$age) + linear_model$coefficients[3]
lsm_assist
```



### Interaction Test 
```{r}
interaction_model <- lm(cesd ~ age + publicassist + age:publicassist, data=depression)
summary(interaction_model)

interaction_model2 <- lm(cesd ~ age*publicassist, data=depression)
summary(interaction_model2)

#No Public Assistance
no_assist_interaction_intercept <- interaction_model$coefficients[1]
no_assist_interaction_intercept

no_assist_interaction_beta <- interaction_model$coefficients[2]
no_assist_interaction_beta

#Public Assistance
assist_interaction_intercept <- interaction_model$coefficients[1] + interaction_model$coefficients[3]
assist_interaction_intercept

assist_interaction_beta <- interaction_model$coefficients[2] + interaction_model$coefficients[4]
assist_interaction_beta 

#Plot
plot(cesd ~ age, data=depression, col=c("hotpink", "cyan2"))
abline(no_assist_interaction_intercept, assist_interaction_beta) #No Public Assistance
abline(assist_interaction_intercept, assist_interaction_beta, lty=2) #Public Assistance
```

