import pde
from pde import FieldCollection, PDEBase, UnitGrid, ScalarField
import numpy as np
import json

with open('params.json', 'r') as file:
    params = json.load(file)

class Diffuser(PDEBase):
    def __init__(self, DI, D1, D2, kin, kout, ks, h, Ic, bc="auto_periodic_neumann", **kwargs):
        self.DI = DI
        self.D1 = D1
        self.D2 = D2
        self.kin = kin
        self.kout = kout
        self.ks = ks
        self.h = h
        self.Ic = Ic
        self.bc = bc
        super().__init__(**kwargs)
    def evolution_rate(self, state, t=0):
        DI, D1, D2, kin, kout, ks, h, Ic = self.DI, self.D1, self.D2, self.kin, self.kout, self.ks, self.h, self.Ic
        S, S1, S2, I = state
        H = (Ic**h)/(Ic**h + I**h)
        S1_t = D1 * S1.laplace(bc=self.bc) - H*S1*S2*S2 + kin - kout*S1
        S2_t = D2 * S2.laplace(bc=self.bc) + H*S1*S2*S2 - ks*S2
        I_t = DI * I.laplace(bc=self.bc) + ks*S2
        S_t = ks*S2
        return FieldCollection([S_t, S1_t, S2_t, I_t])

diffuser = Diffuser(**params)
def solve(canvas):
    """
    Solve the reaction-diffusion simulation on the given canvas.

    Parameters:
    - canvas: numpy.ndarray
        The initial canvas representing the state of the simulation.

    Returns:
    - numpy.ndarray
        The final state of the simulation after solving.
    """
    height, width = canvas.shape
    grid = UnitGrid([height, width])
    S = ScalarField(grid, canvas)
    I = ScalarField.random_uniform(grid, 0, 1)
    S1 = ScalarField.random_uniform(grid, 0, 1)
    S2 = ScalarField.random_uniform(grid, 0, 1)
    state = FieldCollection([S, S1, S2, I])
    result = diffuser.solve(state, t_range=100, dt=1)
    return result.data[0]