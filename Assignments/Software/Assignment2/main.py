import itertools as it

class Graph:
    def __init__(self, gdict = None):
        if gdict is None:
            gdict = {}
        self.gdict = gdict

    def edges(self):
        edgename = []
        for vrtx in self.gdict:
            for nxtvrtx in self.gdict[vrtx]:
                if [vrtx, nxtvrtx] not in edgename:
                    edgename.append([vrtx, nxtvrtx])
        return edgename
    
    def AddEdge(self, edge, delay, area, part):
        if part=="A":
            if edge[0] in self.gdict:
                self.gdict[edge[0]].append([edge[1], float(delay), float(area)])
            else:
                self.gdict[edge[0]] = [[edge[1], float(delay), float(area)]]
        else:
            if edge[0] in self.gdict:
                self.gdict[edge[0]].append([edge[1], delay, area])
            else:
                self.gdict[edge[0]] = [[edge[1], delay, area]]

s = input().split()
part = s[0]
cir = s[1]
gd = s[2]
ld = s[3]
try:
    ma = s[4]
except:
    ma = 0

f = open(gd, "r")
delays = {"INV":[], "NAND2":[], "AND2":[], "OR2":[], "NOR2":[]}
areas = {"INV":[], "NAND2":[], "AND2":[], "OR2":[], "NOR2":[]}
for x in f:
    if len(x)==0 or x.startswith("//") or x.isspace():
        continue
    else:
        line = x.split()
        delays[line[1]].append(float(line[2]))
        areas[line[1]].append(float(line[3]))
f.close()

for i in list(delays.keys()):
    delays[i].sort()
for j in list(areas.keys()):
    areas[j].sort(reverse=True)

f = open(cir, "r")
nodes = {}
inputs = {}
outputs = {}
signals = {}
gat = {}
gates = 0
g = Graph()
count = 0
for x in f:
    if len(x)==0 or x.startswith("//") or x.isspace():
        continue
    else:
        line = x.split()
        if line[0] in ["PRIMARY_INPUTS", "PRIMARY_OUTPUTS", "INTERNAL_SIGNALS"]:
            if line[0]=="PRIMARY_INPUTS":
                for y in line[1:]:
                    inputs.update({y: 0})
                    nodes.update({y:False})
            if line[0]=="PRIMARY_OUTPUTS":
                for y in line[1:]:
                    outputs.update({y: -float("inf")})
                    nodes.update({y:False})
            if line[0]=="INTERNAL_SIGNALS":
                for y in line[1:]:
                    signals.update({y: -float("inf")})
                    nodes.update({y:False})
        else:
            if line[0]=="INV":
                gates+=1
                gat.update({line[1]+line[2]:["INV", delays["INV"], areas["INV"]]})
                if part=="A":
                    g.AddEdge([line[1], line[2]], min(delays["INV"]), areas["INV"][delays["INV"].index(min(delays["INV"]))], part)
                else:
                    g.AddEdge([line[1], line[2]], delays["INV"], areas["INV"], part)
            elif line[0]=="DFF":
                if (line[2] not in inputs.keys() and line[2] in signals.keys()):
                    signals.pop(line[2])
                    inputs.update({line[2]:0})
                elif (line[2] in inputs.keys() and line[2] not in signals.keys()):
                    signals.pop(line[2])
                if (line[1] not in outputs.keys() and line[1] in signals.keys()):
                    signals.pop(line[1])
                    outputs.update({line[1]:-float("inf")})
                elif (line[1] in outputs.keys() and line[1] in signals.keys()):
                    signals.pop(line[1])
            else:
                gates+=1
                gat.update({line[1]+ " " + line[2]+ " " + line[3]:[line[0], delays[line[0]], areas[line[0]]]})
                if part=="A":
                    g.AddEdge([line[1], line[3]], min(delays[line[0]]), areas[line[0]][delays[line[0]].index(min(delays[line[0]]))], part)
                    g.AddEdge([line[2], line[3]], min(delays[line[0]]), areas[line[0]][delays[line[0]].index(min(delays[line[0]]))], part)
                else:
                    g.AddEdge([line[1], line[3]], delays[line[0]], areas[line[0]], part)
                    g.AddEdge([line[2], line[3]], delays[line[0]], areas[line[0]], part)
for x in list(inputs.keys()):
    if x in list(signals.keys()):
        signals.pop(x)
for y in list(outputs.keys()):
    if y in list(signals.keys()):
        signals.pop(y)
f.close()

def generate_permutations(n, current_permutation=[]):
    types = [0, 1, 2]
    if n == 0:
        list2.append(current_permutation)
        return
    for type in types:
        generate_permutations(n - 1, current_permutation + [type])

def dfs_util(part, node):
    if part=="A":
        if node not in outputs:
            for i in range(len(g.gdict[node])):
                if g.gdict[node][i][0] in signals.keys():
                    if node in signals:
                        signals[g.gdict[node][i][0]] = max(signals[g.gdict[node][i][0]], signals[node] + float(g.gdict[node][i][1]))
                    elif node in inputs:
                        signals[g.gdict[node][i][0]] = max(signals[g.gdict[node][i][0]], inputs[node] + float(g.gdict[node][i][1]))
                elif g.gdict[node][i][0] in outputs.keys():
                    if node in signals:
                        outputs[g.gdict[node][i][0]] = max(outputs[g.gdict[node][i][0]], signals[node] + float(g.gdict[node][i][1]))
                    elif node in inputs:
                        outputs[g.gdict[node][i][0]] = max(outputs[g.gdict[node][i][0]], inputs[node] + float(g.gdict[node][i][1]))
                dfs_util(part, g.gdict[node][i][0])

def dfs(part):
    if part=="A":
        l = list(inputs.keys())
        for i in range(len(inputs)):
            dfs_util(part, l[i])
        return max(outputs.values())

def dfs_util1(part, node, maxdelay, lis):
    if part=="B":
        if node not in outputs:
            for i in range(len(g.gdict[node])):
                if g.gdict[node][i][0] in signals.keys():
                    if node in signals.keys():
                        l1 = list(gat.keys())
                        for k in range(len(l1)):
                            if node in l1[k] and g.gdict[node][i][0] in l1[k]:
                                d = gat[l1[k]][1][lis[k]]
                                break
                        signals[g.gdict[node][i][0]] = max(signals[g.gdict[node][i][0]], signals[node] + float(d))
                    elif node in inputs.keys():
                        l1 = list(gat.keys())
                        for k in range(len(l1)):
                            if node in l1[k] and g.gdict[node][i][0] in l1[k]:
                                d = gat[l1[k]][1][lis[k]]
                        signals[g.gdict[node][i][0]] = max(signals[g.gdict[node][i][0]], inputs[node] + float(d))
                elif g.gdict[node][i][0] in outputs.keys():
                    if node in signals.keys():
                        l1 = list(gat.keys())
                        for k in range(len(l1)):
                            if node in l1[k] and g.gdict[node][i][0] in l1[k]:
                                d = gat[l1[k]][1][lis[k]]
                        outputs[g.gdict[node][i][0]] = max(outputs[g.gdict[node][i][0]], signals[node] + float(d))
                    elif node in inputs.keys():
                        l1 = list(gat.keys())
                        for k in range(len(l1)):
                            if node in l1[k] and g.gdict[node][i][0] in l1[k]:
                                d = gat[l1[k]][1][lis[k]]
                        outputs[g.gdict[node][i][0]] = max(outputs[g.gdict[node][i][0]], inputs[node] + float(d))
                dfs_util1(part, g.gdict[node][i][0], maxdelay, lis)

def dfs1(part, maxdelay, lis):
    if part=="B":
        for i in range(len(inputs)):
            dfs_util1(part, list(inputs.keys())[i], maxdelay, lis)
    return max(outputs.values())
        
if part == "A":
    x = dfs("A")
    f = open(ld, "w")
    f.write(str(x))
    f.close()
else:
    f = open(ld, "r")
    for x in f:
        maxdelay = float(x)
    f.close()
    if len(gat)<10:
        list2 = []
        generate_permutations(gates)
        minarea = float("inf")
        for i in list2:
            num = dfs1("B", maxdelay, i)
            for c in list(outputs.keys()):
                outputs[c] = -float("inf")
            for dk in list(signals.keys()):
                signals[dk] = -float("inf")
            if num<=maxdelay:
                area = 0
                l1 = list(gat.keys())
                for k in range(len(l1)):
                    area+=gat[l1[k]][2][i[k]]
                minarea = min(minarea, area)
                j = i
    else:
        i = [0 for k in range(len(gat))]
        minarea = float("inf")
        for z in range(2):
            for x in range(len(gat)):
                tempmin = float("inf")
                temp1 = 0
                for y in range(3):
                    i[x] = y
                    num = dfs1("B", maxdelay, i)
                    if num<=maxdelay:
                        area = 0
                        l1 = list(gat.keys())
                        for k in range(len(l1)):
                            area+=gat[l1[k]][2][i[k]]
                        if tempmin>area:
                            tempmin = area
                            temp1 = y
                minarea = min(tempmin, minarea)
                i[x] = temp1

    f = open(ma, "w")
    f.write(str(minarea))
    f.close()
