#!/usr/local/bin/python
###################################################
#
# PKsumv6.py
# Goal: implement biased LexRank for either single docs or a multi doc corpus
# called as python PKsumv3.py text_path_or_file 
# By Jeffrey Herbstman, 7-15-2013
# 
# Inputs:
#  path - text file or directory containing text files
#  output - output file name
# optional inputs:
#  posseed - seed string for positively biased LexRank
#  negseed - seed string for negatively biased LexRank
#  stopfile - file containing custom stopwords
#  length - int - length (in lines) of summary
#  seed_posweight - weights the positive seed similarity score
#  seed_negweight - weights the negative seed similarity score
#  ngrams - allows ngram measurements
#
# Outputs:
# single file with name provided as input (see above)
#
#Options to possibly add:
# - normalization: right now the cosine similarity measure incorporates a 
#normalization method. I'm not sure how to sub in a different, still effective
#method instead of that  
# - Stemming
#
###################################################
import scipy, numpy, codecs, os
import sys, nltk, collections, sklearn.feature_extraction.text, networkx, time
import scipy.spatial.distance
import biased_lexrank
import argparse


#==================================================
#defines a class consisting of a list of sentences pulled from the text doc
class Corpus:
    def __init__(self, input_text):
        self.documents = self._index_docs(input_text)
        
    def ls(self, path):
        return [os.path.join(path, item) for item in os.listdir(path)]
        
    def file_read(self, input_text):
        
        doc = (file.read(file(input_text))).decode('utf-8', 'replace')
        
        #Sentence tokenizing
        doc = ' '.join(doc.strip().split('\n'))
        sentence_tokenizer = nltk.PunktSentenceTokenizer()
        sentences = sentence_tokenizer.tokenize(doc)
        return sentences
        
    def _index_docs(self, input_text):
        sentences = []
        try:
            sentences = self.file_read(input_text)
        except IOError:
            for f in self.ls(input_text):
                single_doc_sentences = []
                single_doc_sentences = self.file_read(f)
                sentences.extend(single_doc_sentences)
        
        #removes arbitrarily long lists
        sentences = [sent for sent in sentences if sent.count(',') < 12]
            
                
        return sentences



#==================================================
#creates a Term-Document Matrix for the corpus
class TDM:
    def __init__(self, corpus, posseed, negseed, stopfile, norm_flag, ngram):
        
        #Normalization flag encoding
        if norm_flag == 'True':
            norm_opt = 'l2'
        else: 
            norm_opt = None
            
        #Stopword encoding
        if stopfile == None:
            stop_words = 'english'
        else:
            with codecs.open(stopfile, encoding='utf-8') as f:
                stop_words = f.read()
                
        if posseed == None and negseed == None:
            self.matrix = self._gen_matrix(corpus, stop_words, norm_opt, ngram)
        else:
            self.matrix = self._gen_matrix_seeded(corpus, posseed, negseed, stop_words, norm_opt, ngram)
        
            
            
    def _gen_matrix(self, corpus, stop_words, norm_opt, ngram): 
        
        #TDM generator
        count_vec = sklearn.feature_extraction.text.CountVectorizer( 
            stop_words, ngram_range=(1, ngram))
        try:
            term_matrix = count_vec.fit_transform(corpus)
        except ValueError:
            print("This document isn't summarizable.")
            sys.exit()
        normalized = sklearn.feature_extraction.text.TfidfTransformer(norm=norm_opt).fit_transform(term_matrix)
        return term_matrix, normalized
    
    def _gen_matrix_seeded(self, corpus, posseed, negseed, stop_words, norm_opt, ngram ):
        #This adds the seed so that it can be properly indexed for later
        #comparison with the TDM
        corpus.insert(0, negseed)
        corpus.insert(0, posseed)
        count_vec = sklearn.feature_extraction.text.CountVectorizer( 
            stop_words, ngram_range=(1, ngram) )
        try:
            term_matrix = count_vec.fit_transform(corpus)
        except ValueError:
            print("This document isn't summarizable.")
            sys.exit()
        term_matrix_seedless = term_matrix.tocsr()[2:,:]
        pos_seed_vector = term_matrix.getrow(0)
        neg_seed_vector = term_matrix.getrow(1)

        #if you want to use normalization 
        normalized = sklearn.feature_extraction.text.TfidfTransformer(norm=norm_opt).fit_transform(term_matrix_seedless)
        
        return term_matrix_seedless, normalized, pos_seed_vector, neg_seed_vector
        
#==================================================
def baseline_scorer(term_matrix, seed_vector):
    #need to compute some measure of similarity between seed vector and matrix
    #could use improved vectorization?
    numerator = term_matrix*seed_vector.T
    seed_norm = numpy.sum(numpy.abs(seed_vector.data)**2)**(1./2)
    term_matrix.data = term_matrix.data**2
    matr_norm = numpy.sqrt(term_matrix.sum(1))
    m = matr_norm.shape[0]
    baseline_score = scipy.zeros(m)

    for n in range(m):
        if matr_norm[n] != 0:
            baseline_score[n] = numerator[n].multiply(1/(seed_norm*matr_norm[n]))
    baseline_score = baseline_score/baseline_score.sum()
    return baseline_score
    
    
#==================================================
class Graph:
    def __init__(self, term_matrix, LR_method, pos_seed_vector, neg_seed_vector, pos_weight, neg_weight):
    #Can add option for different similarity measures here
        self.sim_scores = self._gen_sim_scores(term_matrix, LR_method, pos_seed_vector, neg_seed_vector, pos_weight, neg_weight)
        
        
    def _gen_sim_scores(self, term_matrix, LR_method, pos_seed_vector, neg_seed_vector, pos_weight, neg_weight):
        if LR_method == 'unbiased':
            #Switch from distance to similarity measures here
            weights = -1*(scipy.spatial.distance.pdist(term_matrix.toarray(), 'cosine')-1)
            #check weights here and threshold them
            weights[weights < .2] = 0
            weights[numpy.isnan(weights)] = 0
            
            graph = networkx.from_numpy_matrix(scipy.spatial.distance.squareform(weights))
            scores = networkx.pagerank_scipy(graph, max_iter=5000, alpha = .85)
            
            
        elif LR_method == 'biased':
            weights = -1*(scipy.spatial.distance.pdist(term_matrix.toarray(), 'cosine')-1)
            #check weights here and threshold them
            weights[weights < .2] = 0
            nan2zero(weights)
            
            graph = networkx.from_numpy_matrix(scipy.spatial.distance.squareform(weights))

            
            #check if seed is empty and return something with correct format
            if str(pos_seed_vector.nonzero()) == '(array([], dtype=int32), array([], dtype=int32))':
                pos_seed_scores = scipy.zeros_like(neg_seed_vector)
            else:
                pos_seed_scores = baseline_scorer(term_matrix, pos_seed_vector)

                
            if str(neg_seed_vector.nonzero()) == '(array([], dtype=int32), array([], dtype=int32))':
                neg_seed_scores = scipy.zeros_like(pos_seed_scores)
            else:
                neg_seed_scores = baseline_scorer(term_matrix, neg_seed_vector)
                
            #add a ballast to act against neg seed scores
            ballast = scipy.zeros_like(neg_seed_scores)
            ballast[neg_seed_scores == 0] = neg_weight
            
            seed_scores = pos_seed_scores*pos_weight + neg_seed_scores*neg_weight +ballast
            scores = biased_lexrank.b_lexrank(graph, seed_scores, personalization = 'biased', alpha=.85, max_iter = 5000, seed_weight = pos_weight)
        
        return scores
        
#=================================================
def nan2zero(array):
    array[numpy.isnan(array)] = 0

#=================================================

def print_summary(sentences, scores, out_file, length):
        ranked_sentences = sorted(((scores[i], s, i) for i,s in enumerate(sentences)), reverse = True) 

        top_ranked = ranked_sentences[0:length]

        f = codecs.open(out_file, encoding = 'utf-8', mode = 'w')
#        f.write('# Programmatically Generated Summary: \n\n')
        sorted_sum = sorted(top_ranked, key = lambda top_ranked: top_ranked[2])
        for element in sorted_sum:
            f.write('* ' + element[1] + '\n\n')
        
        f.close()
        
#=================================================
def output_checker(output_file):
    if output_file == None:
        print "Output file name not supplied. Please run again with -o option supplied"
        from sys import exit
        exit()

#=================================================
 
def main():

    
    parser = argparse.ArgumentParser()
    parser.add_argument('path', help = "target file or directory for summarization")
    parser.add_argument("--posseed", help="boosting seed for biased LexRank", default = None)
    parser.add_argument("--negseed", help="blocking seed for biased LexRank", default = None)
    parser.add_argument("--stopfile", help="file containing custom stopwords")
    parser.add_argument("-o", "--output", help = "output file name")
    parser.add_argument("-l", "--length", help = "summary length in lines", default = 10)
    parser.add_argument("--seed_posweight", help = "Weight for positive seed", default = 3)
    parser.add_argument("--seed_negweight", help = "Weight for negative seed", default = .0001)
    parser.add_argument("--ngrams", help = "N-gram number", default = 1)
    #normalization doesn't work due to being inherent within scoring method
    parser.add_argument("-n", "--is_norm", help = "Boolean flag for normalization", default = True)
    args = parser.parse_args()
    
    input_text = args.path
    pos_seed = args.posseed
    neg_seed = args.negseed
    stopfile = args.stopfile
    out_file = args.output
    sum_length = int(args.length)
    norm_flag = args.is_norm
    pos_weight = float(args.seed_posweight)
    neg_weight = float(args.seed_negweight)
    ngram = int(args.ngrams)
    corpus = Corpus(input_text).documents
    
    output_checker(out_file)

    if pos_seed == None and neg_seed == None:
        LR_method = 'unbiased'
        print LR_method
        [term_matrix, normalized] = TDM(corpus, pos_seed, neg_seed, stopfile, norm_flag, ngram).matrix
        pos_seed_vector = []
        neg_seed_vector = []
        
    else:
        LR_method = 'biased'
        if pos_seed == None:
            pos_seed = ''
        if neg_seed == None:
            neg_seed = ''
        
        [term_matrix, normalized, pos_seed_vector, neg_seed_vector] = TDM(corpus, pos_seed, neg_seed, stopfile, norm_flag, ngram).matrix
        corpus = corpus[2:]
        

    scores = Graph(normalized, LR_method, pos_seed_vector, neg_seed_vector, pos_weight, neg_weight).sim_scores 
    print_summary(corpus, scores, out_file, sum_length)
    

#=================================================
if __name__ == '__main__':
    main()
