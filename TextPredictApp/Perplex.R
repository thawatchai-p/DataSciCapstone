library(data.table)
library(quanteda)

load("./data/n_gram_prob.RData")

if(!file.exists("./data/ProbAll.RDS")){
        Prob1g <- data.frame(words = uni_words$word_1, prob = uni_words$prob)
        Prob2g <- data.frame(words = paste(bi_words$word_1, bi_words$word_2, sep = " "), prob = bi_words$prob)
        Prob3g <- data.frame(words = paste(tri_words$word_1, tri_words$word_2, tri_words$word_3, sep = " "), prob = tri_words$prob)
        Prob4g <- data.frame(words = paste(quad_words$word_1, quad_words$word_2, quad_words$word_3, quad_words$word_4, sep = " "), prob = quad_words$prob)
        ProbAll <- list(Prob1g, Prob2g, Prob3g, Prob4g)
        saveRDS(ProbAll, "./data/ProbAll.RDS"); rm(Prob1g, Prob2g, Prob3g, Prob4g)
} else {
        ProbAll <- readRDS("./data/ProbAll.RDS")
        Prob1g <- ProbAll[[1]]
        Prob2g <- ProbAll[[2]]
        Prob3g <- ProbAll[[3]]
        Prob4g <- ProbAll[[4]]
}

Token <- readRDS("./data/cleanToken.RDS")

perplex <- function(ngram) {
        NToken <- tokens_ngrams(Token, n = ngram, skip = 0, concatenator = " ")
        dfmPrep <- dfm(NToken) %>% dfm_trim(min_docfreq = 1)
        TokenPerp <- featnames(dfmPrep)
        N <- length(TokenPerp)
        lognProb <- data.frame(logProb = log(ProbAll[[ngram]]$prob))
        Perplex <- exp((-1/N)*sum(lognProb))
        Perplex <- round(Perplex, 0)
        return(Perplex)
}

# perplex(1) = 1161536
# perplex(2) = 298
# perplex(3) = 13
# perplex(4) = 4

# End of Code