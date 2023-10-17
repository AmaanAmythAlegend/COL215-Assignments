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
    
    def AddEdge(self, edge, delay, area):
        if edge[0] in self.gdict:
            self.gdict[edge[0]].append([edge[1], delay, area])
        else:
            self.gdict[edge[0]] = [[edge[1], delay, area]]

f = open("gate_delays.txt", "r")
delays = {"INV":[], "NAND2":[], "AND2":[], "OR2":[], "NOR2":[]}
areas = {"INV":[], "NAND2":[], "AND2":[], "OR2":[], "NOR2":[]}
for x in f:
    if len(x)==0 or x.startswith("//") or x.isspace():
        continue
    else:
        line = x.split()
        delays[line[1]].append(line[2])
        areas[line[1]].append(line[3])

f.close()

f = open("circuit.txt", "r")
inputs = {}
outputs = {}
signals = {}
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
            if line[0]=="PRIMARY_OUTPUTS":
                for y in line[1:]:
                    outputs.update({y: -float("inf")})
            if line[0]=="INTERNAL_SIGNALS":
                for y in line[1:]:
                    signals.update({y: -float("inf")})
        else:
            if line[0]=="INV":
                g.AddEdge([line[1], line[2]], min(delays["INV"]), areas["INV"][delays["INV"].index(min(delays["INV"]))])
            elif line[0]=="DFF":
                if (line[2] not in inputs.keys() and line[2] in signals.keys()):
                    signals.pop(line[2])
                    inputs.update({line[2]:0})
                elif (line[2] in inputs.keys() and line[2] in signals.keys()):
                    signals.pop(line[2])
                if (line[1] not in outputs.keys() and line[1] in signals.keys()):
                    signals.pop(line[1])
                    outputs.update({line[1]:-float("inf")})
                elif (line[1] in outputs.keys() and line[1] in signals.keys()):
                    signals.pop(line[1])
            else:
                g.AddEdge([line[1], line[3]], min(delays[line[0]]), areas[line[0]][delays[line[0]].index(min(delays[line[0]]))])
                g.AddEdge([line[2], line[3]], min(delays[line[0]]), areas[line[0]][delays[line[0]].index(min(delays[line[0]]))])

f.close()

""" print(inputs)
print(outputs)
print(signals)
print(g.gdict) """

def dfs()