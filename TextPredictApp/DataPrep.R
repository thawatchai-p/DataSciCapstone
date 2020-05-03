library(quanteda)
library(data.table)

if(!file.exists("./data/corpus.RDS")){
        SampleBlogs <- readRDS("./data/Sampleblogs.RDS")
        SampleNews <- readRDS("./data/Samplenews.RDS")
        SampleTwitt <- readRDS("./data/Sampletwitter.RDS")
        closeAllConnections()
        corp <- corpus(c(SampleBlogs, SampleNews, SampleTwitt))
        rm(SampleBlogs, SampleNews, SampleTwitt)
        saveRDS(corp, "./data/corpus.RDS")
} else {
        corp <- readRDS("./data/corpus.RDS")
}

corp <- iconv(corp, "latin1", "ASCII", sub="")
corp <- tolower(corp)
corp <- gsub("(f|ht)tp(s?)://\\S+", "", corp, perl=TRUE)
corp <- gsub("[[:alnum:].-]+@[[:alnum:].-]+", "", corp, perl = TRUE)
corp <- gsub("@\\S+", "", corp, perl = TRUE)
corp <- gsub("#\\S+", "", corp, perl = TRUE)
corp <- gsub("[[:digit:]]", "", corp, perl = TRUE)
corp <- gsub("\\s*(?:(?:\\B[-'&]+|[-'&]+\\B|[^-'&[:^punct:]]+)\\s*)+", " ", corp, perl=TRUE)
corp <- gsub("([[:alpha:]])\\1{3,}", "\\1\\1", corp, perl = TRUE)

Token <- tokens(corp, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove_separators = TRUE, split_hyphens = TRUE)
rm(corp)

profanityURL <- url("http://www.bannedwordlist.com/lists/swearWords.txt")
profanity <- readLines(profanityURL, warn = FALSE)
close(profanityURL)
Token <- tokens_remove(Token, pattern = profanity)
Token <- tokens_remove(Token, pattern = "#\\S+", valuetype = "regex")
Token <- tokens_remove(Token, pattern = "[[:digit:]]", valuetype = "regex")
saveRDS(Token, "./data/cleanToken.RDS") # Token <- readRDS("./data/cleanToken.RDS")
rm(profanity, profanityURL)

dfm1g <- tokens_ngrams(Token, n = 1, skip = 0, concatenator = " ") %>% dfm() %>% dfm_trim(min_docfreq = 1)
dfm2g <- tokens_ngrams(Token, n = 2, skip = 0, concatenator = " ") %>% dfm() %>% dfm_trim(min_docfreq = 1)
dfm3g <- tokens_ngrams(Token, n = 3, skip = 0, concatenator = " ") %>% dfm() %>% dfm_trim(min_docfreq = 1)
dfm4g <- tokens_ngrams(Token, n = 4, skip = 0, concatenator = " ") %>% dfm() %>% dfm_trim(min_docfreq = 1)
rm(Token)

sums1g <- colSums(dfm1g); rm(dfm1g)
sums2g <- colSums(dfm2g); rm(dfm2g)
sums3g <- colSums(dfm3g); rm(dfm3g)
sums4g <- colSums(dfm4g); rm(dfm4g)

d1 <- data.table(word = names(sums1g), freq = sums1g); rm(sums1g)
d2 <- data.table(word = names(sums2g), freq = sums2g); rm(sums2g)
d3 <- data.table(word = names(sums3g), freq = sums3g); rm(sums3g)
d4 <- data.table(word = names(sums4g), freq = sums4g); rm(sums4g)

d1 <- d1[order(-freq)]
d2 <- d2[order(-freq)]
d3 <- d3[order(-freq)]
d4 <- d4[order(-freq)]

uni_words <- data.frame(word_1 = d1$word, count = d1$freq, stringsAsFactors = FALSE)

bi_words <- data.frame(
        word_1 = sapply(strsplit(as.character(d2$word), " ", fixed = TRUE), '[[', 1),
        word_2 = sapply(strsplit(as.character(d2$word), " ", fixed = TRUE), '[[', 2),
        count = d2$freq, stringsAsFactors = FALSE)

tri_words <- data.frame(
        word_1 = sapply(strsplit(as.character(d3$word), " ", fixed = TRUE), '[[', 1),
        word_2 = sapply(strsplit(as.character(d3$word), " ", fixed = TRUE), '[[', 2),
        word_3 = sapply(strsplit(as.character(d3$word), " ", fixed = TRUE), '[[', 3),
        count = d3$freq, stringsAsFactors = FALSE)

quad_words <- data.frame(
        word_1 = sapply(strsplit(as.character(d4$word), " ", fixed = TRUE), '[[', 1),
        word_2 = sapply(strsplit(as.character(d4$word), " ", fixed = TRUE), '[[', 2),
        word_3 = sapply(strsplit(as.character(d4$word), " ", fixed = TRUE), '[[', 3),
        word_4 = sapply(strsplit(as.character(d4$word), " ", fixed = TRUE), '[[', 4),
        count = d4$freq, stringsAsFactors = FALSE)

rm(d1, d2, d3, d4)

saveRDS(uni_words, "./data/uni_words.RDS")    # uni_words <- readRDS("./data/uni_words.RDS"); u <- readRDS("./data/uni_words.RDS")
saveRDS(bi_words, "./data/bi_words.RDS")      # bi_words <- readRDS("./data/bi_words.RDS"); b <- readRDS("./data/bi_words.RDS")
saveRDS(tri_words, "./data/tri_words.RDS")    # tri_words <- readRDS("./data/tri_words.RDS"); t <- readRDS("./data/tri_words.RDS")
saveRDS(quad_words, "./data/quad_words.RDS")  # quad_words <- readRDS("./data/quad_words.RDS"); q <- readRDS("./data/quad_words.RDS")
gc(verbose = FALSE)

# N-Gram model probablity with Kneser Kney Smoothing
# http://computational-linguistics-class.org/slides/04-n-gram-language-models.pdf
# page 66

discount_value <- 0.75

# uni-gram
uni_words$prob <- uni_words$count / sum(uni_words$count)
uni_words$word_1 <- as.character(uni_words$word_1)

# bi-gram
bi_w1_count <- aggregate(bi_words[,'word_1'],by=list(bi_words[,'word_1']),length)
names(bi_w1_count) <- c('word_1','count')

bi_words <- merge(bi_words,uni_words[,c('word_1','count')],by.x='word_1',by.y='word_1',all.x=T)
names(bi_words) <- c("word_1","word_2",'count','word_1_uni_count')

bi_words <- merge(bi_words,bi_w1_count,by='word_1',all.x=T)
names(bi_words) <- c('word_1','word_2','count','word_1_uni_count','word_1_bi_count')

bi_words <- merge(bi_words,uni_words[,c('word_1','prob')],by.x='word_1',by.y='word_1',all.x=T)
names(bi_words) <- c('word_1','word_2','count','word_1_uni_count','word_1_bi_count','word_2_uni_prob')

bi_words$prob <- (bi_words$count - discount_value)/bi_words$word_1_uni_count + discount_value/bi_words$word_1_uni_count*bi_words$word_1_bi_count*bi_words$word_2_uni_prob
bi_words <- bi_words[,c('word_1','word_2','count','word_1_uni_count','word_1_bi_count','word_2_uni_prob','prob')]
bi_words <- bi_words[order(bi_words$word_1,bi_words$word_2),]

bi_words$word_1 <- as.character(bi_words$word_1)
bi_words$word_2 <- as.character(bi_words$word_2)

rm(bi_w1_count)

# tri-gram
tri_w12_count <- aggregate(tri_words[,c('word_1')],by=list(tri_words$word_1,tri_words$word_2),length)
names(tri_w12_count) <- c('word_1','word_2','count')

tri_words <- merge(tri_words,bi_words[,c('word_1','word_2','count')],by=c('word_1','word_2'),all.x=T,all.y=F)
names(tri_words) <- c('word_1','word_2','word_3','count','word_12_bi_count')

# Cn2 = word_12_bi_count  
tri_words <- merge(tri_words,tri_w12_count,by=c('word_1','word_2'),all.x=T)
names(tri_words) <- c('word_1','word_2','word_3','count','word_12_bi_count','word_12_tri_count')

tri_words <- merge(tri_words,bi_words[,c('word_1','word_2','prob')],by.x=c('word_1','word_2'),by.y=c('word_1','word_2'),all.x=T)
names(tri_words) <- c('word_1','word_2','word_3','count','word_12_bi_count','word_12_tri_count','word_12_bi_prob')

tri_words$prob <- (tri_words$count - discount_value)/tri_words$word_12_bi_count + discount_value/tri_words$word_12_bi_count*tri_words$word_12_tri_count*tri_words$word_12_bi_prob

tri_words$word_1 <- as.character(tri_words$word_1)
tri_words$word_2 <- as.character(tri_words$word_2)
tri_words$word_3 <- as.character(tri_words$word_3)

rm(tri_w12_count)

# quad-gram
quad_w123_count <- aggregate(quad_words[,c('word_1')],by=list(quad_words$word_1,quad_words$word_2,quad_words$word_3),length)
names(quad_w123_count) <- c('word_1', 'word_2', 'word_3', 'count')

quad_words <- merge(quad_words, tri_words[,c('word_1','word_2','word_3', 'count')],by=c('word_1','word_2','word_3'),all.x=T,all.y=F)
names(quad_words) <- c('word_1','word_2','word_3','word_4','count','word_123_tri_count')

# Cn3 = word_123_tri_count
quad_words <- merge(quad_words, quad_w123_count, by=c('word_1','word_2','word_3'),all.x=T)
names(quad_words) <- c('word_1','word_2','word_3','word_4','count','word_123_tri_count','word_123_quad_count')

quad_words <- merge(quad_words, tri_words[,c('word_1','word_2','word_3','prob')],by.x=c('word_1','word_2','word_3'),by.y=c('word_1','word_2','word_3'),all.x=T)
names(quad_words) <- c('word_1','word_2','word_3','word_4','count','word_123_tri_count','word_123_quad_count','word_123_tri_prob')

quad_words$prob <- (quad_words$count - discount_value)/quad_words$word_123_tri_count + discount_value/quad_words$word_123_tri_count*quad_words$word_123_quad_count*quad_words$word_123_tri_prob

quad_words$word_1 <- as.character(quad_words$word_1)
quad_words$word_2 <- as.character(quad_words$word_2)
quad_words$word_3 <- as.character(quad_words$word_3)
quad_words$word_4 <- as.character(quad_words$word_4)

rm(quad_w123_count, discount_value)

all_words <- list(uni_words, bi_words, tri_words, quad_words)
saveRDS(all_words, "./data/all_words.RDS")    # all_words <- readRDS(./data/all_words.RDS")
save(uni_words, bi_words, tri_words, quad_words, file='./data/n_gram_prob.RData')

# End of Code