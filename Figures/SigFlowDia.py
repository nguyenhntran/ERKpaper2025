import control as ctrl
import networkx as nx
import matplotlib.pyplot as plt

# Define the state-space matrices
A = [[0.5, 1.0], [0.2, 0.3]]
B = [[1.0], [0.5]]
C = [[1.0, 0.5]]
D = [[0.0]]

# Create the state-space system
sys = ctrl.ss(A, B, C, D)

# Create a directed graph
G = nx.DiGraph()

# Add nodes: u for input, x1, x2 for state variables, y for output
G.add_node('u', label='u (Input)')
G.add_node('x1', label='x1 (State 1)')
G.add_node('x2', label='x2 (State 2)')
G.add_node('y', label='y (Output)')

# Add edges based on matrices B, A, C, and D
# B Matrix: from input u to states x1 and x2
G.add_edge('u', 'x1', weight=B[0][0], label=f'B[0][0]={B[0][0]}')
G.add_edge('u', 'x2', weight=B[1][0], label=f'B[1][0]={B[1][0]}')

# A Matrix: from states to other states
G.add_edge('x1', 'x1', weight=A[0][0], label=f'A[0][0]={A[0][0]}')
G.add_edge('x1', 'x2', weight=A[0][1], label=f'A[0][1]={A[0][1]}')
G.add_edge('x2', 'x1', weight=A[1][0], label=f'A[1][0]={A[1][0]}')
G.add_edge('x2', 'x2', weight=A[1][1], label=f'A[1][1]={A[1][1]}')

# C Matrix: from states x1, x2 to output y
G.add_edge('x1', 'y', weight=C[0][0], label=f'C[0][0]={C[0][0]}')
G.add_edge('x2', 'y', weight=C[0][1], label=f'C[0][1]={C[0][1]}')

# D Matrix: from input u to output y (if D is non-zero)
if D[0][0] != 0:
    G.add_edge('u', 'y', weight=D[0][0], label=f'D[0][0]={D[0][0]}')

# Plot the graph
pos = nx.spring_layout(G)  # Positions for all nodes

# Draw the nodes
nx.draw(G, pos, with_labels=True, node_size=2000, node_color='lightblue')

# Draw the edges with labels
edge_labels = nx.get_edge_attributes(G, 'label')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

# Show the plot
plt.show()