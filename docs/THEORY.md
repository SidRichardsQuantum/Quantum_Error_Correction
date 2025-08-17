# Theory: Quantum Error Correction (QEC)

This document explains the physics background for the code in this repository, so the implementation can be understood without external references.

## 1. Why Error Correction?

Quantum bits (qubits) are fragile: interaction with the environment (decoherence) or imperfect control operations cause errors.
Unlike classical bits, qubits cannot be cloned, so redundancy must be introduced carefully.
Quantum Error Correction (QEC) provides a way to detect and correct certain errors without directly measuring and destroying the encoded quantum information.

## 2. Bit-Flip Errors

The simplest error is a **bit flip**, analogous to flipping a classical 0 → 1 or 1 → 0. In operator form this is the Pauli-X operator:

```
X |0⟩ = |1⟩,
X |1⟩ = |0⟩
```

If qubits independently undergo bit flips with probability $p$, the logical information is quickly lost.

## 3. Three-Qubit Repetition Code

To protect against a single bit flip, we encode:

```
|0_L⟩ = |000⟩,
|1_L⟩ = |111⟩
```

So an arbitrary qubit $α|0⟩ + β|1⟩$ is mapped to:

```
|ψ_L⟩ = α |000⟩ + β |111⟩
```

This code can correct one bit flip (on any of the three physical qubits), but fails if two or more flips occur.

## 4. Stabilizer Formalism

The code space is defined by two stabilizer generators:

```
Z_1 Z_2,
Z_2 Z_3
```

- Measuring these operators yields **syndrome bits** that identify which qubit flipped.  
- For example:  
  - Syndrome (1,0) → flip on qubit 1  
  - Syndrome (1,1) → flip on qubit 2  
  - Syndrome (0,1) → flip on qubit 3  

These measurements do not collapse the logical state, only reveal parity information.

## 5. Correction and Decoding

- Once a syndrome is observed, apply the corresponding Pauli-X operator to reverse the error.  
- Finally, to recover the logical bit, perform a **majority vote** measurement on the three physical qubits.

This procedure corrects all single-qubit flips.

## 6. Logical Error Rate

Let $p$ be the single-qubit flip probability.  
- Probability of no error: $(1-p)^3$  
- Probability of exactly one error (correctable): $3p(1-p)^2$  
- Probability of two or three errors (uncorrectable): $3p^2(1-p) + p^3$

So the logical failure rate is:

```
P_\text{fail} = 3p^2(1-p) + p^3
```

This shows how error correction suppresses errors for small $p$ (logical error scales as $p^2$ instead of $p$).

## 7. Limitations and Extensions

- The 3-qubit code only handles bit-flip errors.  
- To correct phase flips, one can use an analogous **phase-flip code**.  
- Combining both yields **Shor’s 9-qubit code**, which protects against arbitrary single-qubit errors.  
- More advanced codes (Steane code, surface code) generalize this idea further.

## 8. Connection to This Repo

- `src/` implements encoding, syndrome measurement, correction, and decoding.  
- `examples/` run Monte Carlo simulations of the error channel and generate plots:
  - Logical error probability vs $p$  
  - Syndrome histograms  
  - Confusion matrices  
  - Error-weight distributions  

These simulations illustrate the mathematics above in a concrete way.

---

📘 Author: Sid Richards (SidRichardsQuantum)

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" width="20" /> LinkedIn: https://www.linkedin.com/in/sid-richards-21374b30b/

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
