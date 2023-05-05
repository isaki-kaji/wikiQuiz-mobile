#完成版が見つからない

import wikipedia
import re
import MeCab
import neologdn

quiz_name=""

sin_text=[]
final_text=[]

wiki_text=wikipedia.page(quiz_name).content
wiki_text=wiki_text.strip().split("\n")
for i in wiki_text:
    nihongo=re.sub(r"[\a-zA-Z0-9_]","",i)
    if len(nihongo)>80:
        sin_text.append(i)
tagger=MeCab.Tagger('-d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
for texts in sin_text:
    keywords=set()
    new_keywords=set()
    result=tagger.parse(texts)
    sakumon=result.split("\n")
    target="名詞"
    for words in sakumon:
        if "固有名詞" in words:
            idx=words.find(target)
            words=words[:idx]
            words=words.replace("\t","")
            keywords.add(words)
#クイズの名前が空欄にならないようにする。    
    for i in keywords:
        if len({*i}&{*quiz_name})<2:
            new_keywords.add(i)
    for key in new_keywords:
        texts=texts.replace(key,"{"+key+"}")
    keywords.clear()
    new_keywords.clear()
    final_text.append(texts)
print(*final_text,sep="\n\n")  