res = []

with open("a", 'r') as f:
	for line in f:
		print(line)
		res.append(line)

with open("b", 'r') as f:
	for line in f:
		print(line)
		res.append(line)

for i in range(len(res[0])):
	pass	
	#print(i, ord(res[0][i]), ord(res[1][i]))		
