function nodes_array 
% Function create an array for the nodes in FiberSim 

% Variables
v = [1;2]
v1 = [1;1]

% Code

% Define zones
p_zone = repmat(v1, 24, 1)'
c_zone = repmat(v,75,1)'
d_zone = repmat(v1, 63, 1)'

% Create a vector 
vector = [p_zone c_zone d_zone]

% Make a json format string 
array = jsonencode([vector])

 

