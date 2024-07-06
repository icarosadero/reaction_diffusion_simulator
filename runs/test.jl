begin
using Pkg
Pkg.activate("./simulator")
Pkg.instantiate()
Pkg.add("YAML")

using simulator
import YAML
end