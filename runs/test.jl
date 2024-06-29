begin
using Pkg
Pkg.activate("./simulator")
#Pkg.instantiate()
#Pkg.add("YAML")
end

begin
using simulator
import YAML
end

begin
params = YAML.load_file("params.yaml")
result = solve_t_pseudonnana("seeds/test.png", params, 1000)
end