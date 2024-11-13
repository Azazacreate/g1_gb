import re               #считает русские И английские
# def isCyrillic(text):
# 	return bool(re.search('[а-яА-Я]', text))

k = "lizard ноутбук".upper()
dict = {1:'AEIOULNSTR,АВЕИНОРСТ',
      	2:'DG,ДКЛМПУ',
      	3:'BCMP,БГЁЬЯ',
      	4:'FHVWY,ЙЫ',
      	5:'K,ЖЗХЦЧ',
      	8:'J,ШЭЮ',
      	10:'QZ,ФЩЪ',}


print(sum([a for i in k for a, v in dict.items() if i in v]))