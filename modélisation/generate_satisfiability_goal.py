import re
from itertools import product

goal = input("(variables with one letter only) goal = ").lower().strip()

letters = list("azertyuiopqsdfghjklwxcvbnm")
variables = list({w for w in re.split(r'\b', goal) if len(w) == 1 and w[0] in letters})
variables.sort()

formulae = []

for interpretation in product(*([[True, False]] * len(variables))):
    formula = goal
    for variable, value in zip(variables, interpretation):
        formula = re.sub(f"\\b{variable}\\b", "true" if value else "false", formula)
    hint = " ".join("T" if value else "F" for value in interpretation)
    formulae.append(f"{formula} (* {hint} *)")

# print("disjunction: " + r" \/ ".join("(" + formula+ ")" for formula in formulae))
# print("conjonction: " + r" /\ ".join("(" + formula+ ")" for formula in formulae))

for i, formula in enumerate(formulae):
    print(f"goal Q1_{i+1}: {formula}")
