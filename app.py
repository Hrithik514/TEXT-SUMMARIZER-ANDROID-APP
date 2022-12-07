from matplotlib.font_manager import json_dump
import numpy as np
from flask import Flask, request, jsonify, render_template
import pickle,json
import time
import sumy
from sumy.parsers.plaintext import PlaintextParser
from sumy.nlp.tokenizers import Tokenizer
from sumy.summarizers.lex_rank import LexRankSummarizer
from sumy.summarizers.luhn import LuhnSummarizer
from sumy.summarizers.lsa import LsaSummarizer
import nltk
nltk.download('punkt')
app = Flask(__name__)
@app.route('/summarize',methods=['POST','GET'])
def luhn_summary():
    #headers={'Content-type':'application/json'}
    #request.headers['Content-Type']="application/json"
    #content = request.get_json(silent=True)
    docx= request.json['text']
    #docx = "A laptop, laptop computer, or notebook computer is a small, portable personal computer with a screen and alphanumeric keyboard. Laptops typically have a clam shell form factor with the screen mounted on the inside of the upper lid and the keyboard on the inside of the lower lid, although 2-in-1 PCs with a detachable keyboard are often marketed as laptops or as having a 'laptop mode'. Laptops are folded shut for transportation, and thus are suitable for mobile use. They are so named because they can be practically placed on a person's lap when being used. Today, laptops are used in a variety of settings, such as at work, in education, for playing games, web browsing, for personal multimedia, and for general home computer use"
    parser = PlaintextParser.from_string(docx,Tokenizer("english"))
    summarizer_luhn = LuhnSummarizer()
    summary_1 =summarizer_luhn(parser.document,3)
    summary_list = [str(sentence) for sentence in summary_1]
    result = ' '.join(summary_list)
    data={'summarize':result}
    #json_dump1=json_dump(data)
    print(data)
    return jsonify(data) 
if __name__ == "__main__":
    app.run(debug=True)
