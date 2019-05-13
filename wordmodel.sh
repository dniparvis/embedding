#!/usr/bin/env bash

#!/usr/bin/env bash

COMMAND=$1

case $COMMAND in
    word2vec)
        echo "word2vec word embedding..."
        python models/word_utils.py train_word2vec data/tokenized_corpus_mecab.txt data/word2vec.vecs
        ;;
    glove)
        echo "glove word embedding..."
        # 각 파일 역할
        # https://github.com/stanfordnlp/GloVe/tree/master/src
        ../glove/build/vocab_count -min-count 5 -verbose 2 < data/tokenized_corpus_mecab.txt > data/glove.vocab
        ../glove/build/cooccur -memory 10.0 -vocab-file data/glove.vocab -verbose 2 -window-size 15 < data/tokenized_corpus_mecab.txt > data/glove.cooc
        ../glove/build/shuffle -memory 10.0 -verbose 2 < data/glove.cooc > data/glove.shuf
        ../glove/build/glove -save-file data/glove.vecs -threads 4 -input-file data/glove.shuf -x-max 10 -iter 15 -vector-size 128 -binary 2 -vocab-file data/glove.vocab -verbose 2
        ;;
    fasttext)
        echo "fasttext word embedding..."
        ../fastText/fasttext skipgram -input data/corpus.txt -output data/fasttext.vecs
        ;;
    swivel)
        echo "swivel word embedding..."
        ../models/research/swivel/fastprep --input data/tokenized_corpus_mecab.txt --output_dir data/swivel.data
        python ../models/research/swivel/swivel.py --input_base_path data/swivel.data --output_base_path data/swivel.data
        ;;
esac