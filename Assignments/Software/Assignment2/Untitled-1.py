y = [6, 7]
def f(x):
    x.append(y)
    print("func", x)

global x
x = [5, 4]
print("main", x)
f(x)
print("main", x)