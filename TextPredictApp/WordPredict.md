Application for Word Prediction
========================================================
author: Thawatchai Phakwithoonchai
date: 03 May 2020 
autosize: true
transition: fade
font-family: 'Lucida'

Overview
========================================================
\---------------------------------------------------------------------------------  
This is the final project of "[Data Science Capstone](https://www.coursera.org/learn/data-science-project)" course, which is a part of Coursera: [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) program offered by Johns Hopkins University (JHU).

Objective of this project is to create the data product or application, which can predict the next word based on the prior words, phrase, or sentence. [Datasets](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip), which are provided by JHU incorporating with [SwiftKey](http://swiftkey.com/en/), are consists of multiple languages; English (en_US), Russian (ru_RU), German (de_DE) and Finnish (fi_FI), while each language dataset consist of 3 different files that is the information gathered from blogs, news, and twitter. For the purpose of this application, only English datasets are used to create the language model.

Application Development Life Cycle
========================================================
\---------------------------------------------------------------------------------  
This application is created, modified, improved through the multiple iterative processes with the following general stages:

- Getting and cleaning the data (lowercase, remove URL, remove E-mail, remove Twitter handle (@...), remove hashtags, remove numbers, remove punctuations, remove [profanity words](http://www.bannedwordlist.com/), remove whitespaces)
- Exploratory data analysis for visualizing the word frequency
- Using [N-gram language model](https://web.stanford.edu/~jurafsky/slp3/3.pdf) and other to build a word prediction framework
- Measuring the model performance by [perplexity](https://en.wikipedia.org/wiki/Perplexity)
- Developing a predictive text application on [shinyapps.io](https://www.shinyapps.io/)

Algorithm and Model
========================================================
\---------------------------------------------------------------------------------  
* Create the different n-gram dataset, in this application, quadgram (n = 4) is the maximum n-gram words for building the language model

* Markov assumption is applied to simplify the n-gram language model

* Kneser–Ney smoothing is applied for calculating the probability distribution of n-grams in the cleaned dataset

* Back-off is also applied for the model when the condition specified the less context and the higher order n-gram model haven’t learned much about



Application
========================================================
\---------------------------------------------------------------------------------
* [**Application**](https://thawatchai-p.shinyapps.io/TextPrediction/) is developed and deployed on the shiny server  

* Web interface allows the users to input the prior words, phrase, or sentence into the text box; and then simply click the "Submit" button

* Result of language model will show the top 10 words that categorized in each n-gram based on the probabilities. 

* Info icon at the sidebar tab is also provided the brief information about the model, its performance, and references.

