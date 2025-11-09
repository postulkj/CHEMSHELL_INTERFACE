# ChemShell–ABIN Interface

This project provides a **Bash-based interface** that connects the **ABIN molecular dynamics (MD) engine** ([ABIN repository](https://github.com/PHOTOX/ABIN)) with the **ChemShell QM/MM framework**. It automates the exchange of structures, energies, and gradients between the two programs, allowing hybrid quantum–classical molecular simulations to run seamlessly.

---

## 🔍 Overview

ABIN performs classical or mixed quantum–mechanical/molecular–mechanical (QM/MM) dynamics. ChemShell computes quantum energies and gradients using external quantum chemistry engines such as MNDO, ORCA, MOLPRO and others.

The interface:
1. Reads atomic coordinates from ABIN’s temporary files.  
2. Converts them into ChemShell input format.  
3. Executes the selected QM code.  
4. Extracts energies and gradients from the output.  
5. Returns them to ABIN for the next MD step.  

This transformation is fully automated in Bash.

---
## ⚙️ Repository Structure

```text
CHEMSHELL_INTERFACE/
├── CHEMSH/
│   └── r.chemsh        # Interface for ground-state MD (ABIN standard mode)
├── CHEMSH-LZ/
│   └── r.chemsh-lz     # Interface for non-adiabatic MD (ABIN LZ mode)
├── SetEnvironment.sh   # Environment setup for ABIN and QM codes
└── .gitignore
```

---

## Interface Versions

**r.chemsh** — couples ChemShell to ABIN for **ground-state molecular dynamics**.  
It transfers geometries, calls the quantum engine (MNDO or ORCA), and returns energies and gradients for each MD step.

**r.chemsh-lz** — adapts the interface for **non-adiabatic (Landau–Zener) dynamics**,  
where ABIN propagates multiple electronic states and changes its file-exchange pattern.  
This version reads state information and prepares corresponding ChemShell/MOLPRO inputs.


---

## 🚀 Usage (conceptual example)

The interface is executed automatically by **ABIN** when placed in the appropriate directory for the calculation.  
ABIN calls the interface script as:

```bash
./r.chemsh $timestep $ibead
```

Parameters of the calculation can be adjusted in **chemsh.inp** or **chemsh-lz.inp**, depending on which interface is used.
The interface can also generate atomic connectivity automatically if required by the selected force field.
