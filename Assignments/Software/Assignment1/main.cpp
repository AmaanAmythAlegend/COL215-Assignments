#include <iostream> 
#include <list> 
#include<map>
#include<string>
#include<algorithm>
#include<fstream>
#include<sstream>

using namespace std; 

class DFSGraph 
{ 
int V, inp, sig, out;
list<int> *adjList;
list<int> *adjList1;
map<map <int,int>, float> weight;
void DFS_util(int v, float val[], map<map<int,int>,float> weight, string part);  // A function used by DFS 
public: 
    // class Constructor
DFSGraph(int V, int inp, int sig, int out)
    {
 this->V = V; 
 this->inp = inp;
 this->sig = sig;
 this->out = out;

    }
    void makelist(){
        adjList = new list<int>[V]; 
        adjList1 = new list<int>[V];
    }
    void iadd(){
        V+=1;
        inp+=1;
    }
    void sadd(){
        V+=1;
        sig+=1;
    }
    void oadd(){
        V+=1;
        out+=1;
    }
    // function to add an edge to graph 
void addEdge(int v, int w, float we){
//weight is a map that stores the weights of all vertices, refer to line 12 for declaration
weight.insert({{{v,w}}, we});
adjList[v].push_back(w); // Add w to v’s list.
adjList1[w].push_back(v);
    }
     
float* DFS(string part, int out_delay[]);    // DFS traversal function 
}; 
void DFSGraph::DFS_util(int v, float val[], map<map<int,int>,float> weight, string part) 
{ 
    // current node v is visited 
    // recursively process all the adjacent vertices of the node 
if (part=="A"){
list<int>::iterator i; 
for(i = adjList[v].begin(); i != adjList[v].end(); ++i) {
val[*i] = max(val[*i], val[v] + weight[{{v,*i}}]);
DFS_util(*i, val, weight, part); 
}
}
else{
list<int>::iterator i; 
for(i = adjList1[v].begin(); i != adjList1[v].end(); ++i) {
    if (val[*i]==0){
        val[*i] = val[v] + weight[{{*i,v}}];
    }
    else{
val[*i] = min(val[*i], val[v] - weight[{{*i,v}}]);
    }
DFS_util(*i, val, weight, part); 
}


} 
}

   
// DFS traversal 
float* DFSGraph::DFS(string part, int out_delay[] = {}) 
{ 
    // initially none of the vertices are visited 
    // all vertice values set to 0
float *val = new float[V]; 
for (int i = 0; i < V; i++) 
val[i] = 0; 

if (part=="A"){   
    // explore only the input vertices one by one by recursively calling  DFS_util
for (int i = 0; i < inp; i++) 
DFS_util(i, val,weight, part); 
return val;
}
else{
    //explore output vertices
for (int j = 0;j<out;j++)
val[inp+sig+j] = out_delay[j];
for (int i = inp + sig; i < V; i++) 
DFS_util(i, val,weight, part);
return val;
}

} 
   
int main() 
{ 

map<string,float> gate;
map<string,int> sig_name;
map<string,int> in_name;
map<string,int> out_name;
int counti = 0;
int counto = 0;
int counts = 0;

string x,y,z,w;
cin>>x>>y>>z>>w;
ifstream f;
f.open(z);
string l;


while (getline(f, l)){
    if (not(l[0] == ' ' or (l[0] == '/' and l[1] == '/') or l.empty() == 1)){
        istringstream x(l);
        string g_name;
        float delay;
        x >> g_name >> delay;
        gate[g_name] = delay;
    }
}
f.close();

DFSGraph gdfs(0,0,0,0);
int j = 0;
f.open(y);
while (getline(f, l)){
    if (not(l[0] == ' ' or (l[0] == '/' and l[1] == '/') or l.empty() == 1)){
        istringstream y(l);
        string type_sig;
        y >> type_sig;
        if (type_sig == "PRIMARY_INPUTS"){
            string inp;
            while(y>>inp){
                in_name[inp] = counti;
                counti+=1;
                gdfs.iadd();
            }
        }
        else if (type_sig == "PRIMARY_OUTPUTS"){
            string o;
            while(y>>o){
                out_name[o] = counto;
                counto+=1;
                gdfs.oadd();
            }
        }
        else if (type_sig == "INTERNAL_SIGNALS"){
            string s;
            y>>s;
            do{
                sig_name[s] = counts;
                counts+=1;
                gdfs.sadd();
            }
            while(y>>s);
        }
        else{
            if (j==0){
                gdfs.makelist();
                j = 1;
            }
            if (type_sig == "INV"){
                string a,b;
                string a1, b1;
                y>>a>>b;
                if (in_name.find(a)!=in_name.end()){
                    a1 = "i";
                }
                else if (sig_name.find(a)!=sig_name.end()){
                    a1 = "s";
                }
                else{
                    a1 = "o";
                }
                if (in_name.find(b)!=in_name.end()){
                    b1 = "i";
                }
                else if (sig_name.find(b)!=sig_name.end()){
                    b1 = "s";
                }
                else{
                    b1 = "o";
                }
                if (a1 == "s" and b1 == "o"){
                    gdfs.addEdge(counti + sig_name[a], counti + counts + out_name[b], gate["INV"]);
                }
                else if (a1 == "s" and b1 == "s"){
                    gdfs.addEdge(counti + sig_name[a], counti + sig_name[b], gate["INV"]);
                }
                else if (a1 == "i" and b1 == "s"){
                    gdfs.addEdge(in_name[a], counti + sig_name[b], gate["INV"]);
                }
                else{
                    gdfs.addEdge(in_name[a], counti + counts + out_name[b], gate["INV"]);
                }
            }
            else{
                string a,b,c;
                string a1,b1,c1;
                y>>a>>b>>c;
                if (in_name.find(a)!=in_name.end()){
                    a1 = "i";
                }
                else if (sig_name.find(a)!=sig_name.end()){
                    a1 = "s";
                }
                else{
                    a1 = "o";
                }
                if (in_name.find(b)!=in_name.end()){
                    b1 = "i";
                }
                else if (sig_name.find(b)!=sig_name.end()){
                    b1 = "s";
                }
                else{
                    b1 = "o";
                }
                if (in_name.find(c)!=in_name.end()){
                    c1 = "i";
                }
                else if (sig_name.find(c)!=sig_name.end()){
                    c1 = "s";
                }
                else{
                    c1 = "o";
                }

                if (a1=="i" and b1=="i" and c1=="s"){
                    gdfs.addEdge(in_name[a], counti + sig_name[c], gate[type_sig]);
                    gdfs.addEdge(in_name[b], counti + sig_name[c], gate[type_sig]);
                }
                else if(a1=="i" and b1=="i" and c1=="o"){
                    gdfs.addEdge(in_name[a], counti + counts + out_name[c], gate[type_sig]);
                    gdfs.addEdge(in_name[b], counti + counts + out_name[c], gate[type_sig]);
                }
                else if(a1=="i" and b1=="s" and c1=="s"){
                    gdfs.addEdge(in_name[a], counti + sig_name[c], gate[type_sig]);
                    gdfs.addEdge(counti + sig_name[b], counti + sig_name[c], gate[type_sig]);
                }
                else if(a1=="i" and b1=="s" and c1=="o"){
                    gdfs.addEdge(in_name[a], counti + counts + out_name[c], gate[type_sig]);
                    gdfs.addEdge(counti + sig_name[b], counti + counts + out_name[c], gate[type_sig]);
                }
                else if(a1=="s" and b1=="i" and c1=="s"){
                    gdfs.addEdge(counti + sig_name[a], counti + sig_name[c], gate[type_sig]);
                    gdfs.addEdge(in_name[b], counti + sig_name[c], gate[type_sig]);
                }
                else if(a1=="s" and b1=="i" and c1=="o"){
                    gdfs.addEdge(counti + sig_name[a], counti + counts + out_name[c], gate[type_sig]);
                    gdfs.addEdge(in_name[b], counti + counts + out_name[c], gate[type_sig]);
                }
                else if(a1=="s" and b1=="s" and c1=="s"){
                    gdfs.addEdge(counti + sig_name[a], counti + sig_name[c], gate[type_sig]);
                    gdfs.addEdge(counti + sig_name[b], counti + sig_name[c], gate[type_sig]);
                }
                else if(a1=="s" and b1=="s" and c1=="o"){
                    gdfs.addEdge(counti + sig_name[a], counti + counts + out_name[c], gate[type_sig]);
                    gdfs.addEdge(counti + sig_name[b], counti + counts + out_name[c], gate[type_sig]);
                }
            }
        }
    }
    else{
        continue;
    }
}
f.close();


    // Create a graph, (total, input, signal, output)
if (x=="A"){
    float* aa;
    aa = gdfs.DFS(x);
    ofstream MyFile("output_delays.txt");
    for(int i = 0;i<counto;i++){
        for (auto const &pair: out_name) {
        if (pair.second == i){
            MyFile<<pair.first<<" "<<aa[counti+counts+i]<<endl;
        }
    }
    }
    MyFile.close();
}
else{
    f.open(w);
    while (getline(f, l)){
        istringstream x1(l);
        string g, d;
        x1 >> g >> d;
        out_name[g] = stof(d);
    }
    f.close();
    float* aa;
    aa = gdfs.DFS(x);
    ofstream MyFile("input_delays.txt");
    for(int i = 0;i<counti;i++){
        for (auto const &pair: in_name) {
        if (pair.second == i){
            MyFile<<pair.first<<" "<<aa[i]<<endl;
        }
    }
    }
    MyFile.close();
}

// same example given in doc
return 0; 

}