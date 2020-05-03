predict_uni <- function() {
        candidates <- uni_words[order(-uni_words$prob),]
        candidates <- candidates[1:50,c('word_1', 'prob')]
        candidates <- sample(candidates$word_1, size = 10, replace = FALSE)
        candidates <- data.frame(candidates=candidates, model='unigram', stringsAsFactors = FALSE)
        return(candidates)
}
# saveRDS(predict_uni, "./data/predict_uni.RDS")

predict_bi <- function(w1) {
        candidates <- bi_words[(bi_words$word_1==w1),c('word_2','prob')]
        candidates <- candidates[order(-candidates$prob),]
        candidates <- candidates[!is.na(candidates$prob),]
        if (nrow(candidates) >= 10){
                candidates <- candidates[1:10,'word_2']
                candidates <- data.frame(candidates=candidates, model='bigram', stringsAsFactors = FALSE)
                return(candidates)
        } else if (nrow(candidates) %in% c(1:9)){
                candidates_bi <- candidates[,'word_2']
                candidates_bi <- data.frame(candidates=candidates_bi, model='bigram', stringsAsFactors = FALSE)
                candidates_uni <- predict_uni()
                candidates <- rbind(candidates_bi, candidates_uni)
                candidates <- candidates[1:10,]
                return(candidates)
        }
        else {
                return(predict_uni())}
}
# saveRDS(predict_bi, "./data/predict_bi.RDS")

predict_tri <- function(w1, w2) {
        candidates <- tri_words[(tri_words$word_1 == w1) & (tri_words$word_2 == w2), c('word_3','prob')]
        candidates <- candidates[order(-candidates$prob),]
        candidates <- candidates[!is.na(candidates$prob),]
        if (nrow(candidates) >= 10){
                candidates <- candidates[1:10,'word_3']
                candidates <- data.frame(candidates=candidates, model='trigram', stringsAsFactors = FALSE)
                return(candidates)
        } else if (nrow(candidates) %in% c(1:9)){
                candidates_tri <- candidates[,'word_3']
                candidates_tri <- data.frame(candidates=candidates_tri, model='trigram', stringsAsFactors = FALSE)
                candidates_bi <- predict_bi(w2)
                candidates <- rbind(candidates_tri, candidates_bi)
                candidates <- candidates[1:10,]
                return(candidates)
        } else {
                return(predict_bi(w2))
        }
}
# saveRDS(predict_tri, "./data/predict_tri.RDS")

predict_quad <- function(w1, w2, w3) {
        candidates <- quad_words[(quad_words$word_1 == w1) & (quad_words$word_2 == w2) & (quad_words$word_3 == w3), c('word_4', 'prob')]
        candidates <- candidates[order(-candidates$prob),]
        candidates <- candidates[!is.na(candidates$prob),]
        if (nrow(candidates) >= 10){
                candidates <- candidates[1:10,'word_4']
                candidates <- data.frame(candidates=candidates, model='quadgram', stringsAsFactors = FALSE)
                return(candidates)
        } else if (nrow(candidates) %in% c(1:9)){
                candidates_quad <- candidates[,'word_4']
                candidates_quad <- data.frame(candidates=candidates_quad, model='quadgram', stringsAsFactors = FALSE)
                candidates_tri <- predict_tri(w1, w2)
                candidates <- rbind(candidates_quad, candidates_tri)
                candidates <- candidates[1:10,]
                return(candidates)
        } else {
                return(predict_tri(w2, w3))
        }
}
# saveRDS(predict_quad, "./data/predict_quad.RDS")

WordPredict <- function(input) {
        input <- tolower(input)
        input <- gsub("(f|ht)tp(s?)://\\S+", "", input, perl=TRUE)
        input <- gsub("[[:alnum:].-]+@[[:alnum:].-]+", "", input, perl = TRUE)
        input <- gsub("@\\S+", "", input, perl = TRUE)
        input <- gsub("#\\S+", "", input, perl = TRUE)
        input <- gsub("[[:digit:]]", "", input, perl = TRUE)
        input <- gsub("\\s*(?:(?:\\B[-'&]+|[-'&]+\\B|[^-'&[:^punct:]]+)\\s*)+", " ", input, perl=TRUE)
        
        Token <- tokens(input, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove_separators = TRUE, split_hyphens = TRUE)
        Token <- unlist(Token[[1]])
        NumToks <- length(Token)
        
        # w1, w2, w3 = 2nd last word, Last word, and all vocabulary words
        if(NumToks == 1) { 
                w1 <- Token[NumToks]
                return(predict_bi(w1))
        }
        if(NumToks == 2) { 
                w1 <- Token[NumToks-1]
                w2 <- Token[NumToks] 
                return(predict_tri(w1, w2))
        }
        if(NumToks >= 3) {
                w1 <- Token[NumToks-2]
                w2 <- Token[NumToks-1]
                w3 <- Token[NumToks]
                return(predict_quad(w1, w2, w3))
        }
}
# saveRDS(WordPredict, "./data/Word_Predict.RDS")

# PredAll <- list(predict_uni, predict_bi, predict_tri, predict_quad, WordPredict)

# saveRDS(PredAll, "./data/PredAll.RDS")
