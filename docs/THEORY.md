# Theory: Quantum Error Correction (QEC)

Important note about the implementation
- This repository implements a classical Monte‑Carlo model of bit‑flip errors using binary vectors and parity checks.
It does not simulate full quantum state vectors or density matrices — errors are modeled as Pauli‑X flips occurring independently with probability $p$.
- The simulations focus on syndrome generation, simple decoders, and logical error statistics from repeated random trials.

### 1. Why Error Correction?

Quantum bits (qubits) are fragile: interaction with the environment (decoherence) or imperfect control operations cause errors.
Because qubits cannot be cloned, redundancy and indirect (syndrome) measurements are used to detect and correct errors without destroying logical information.

### 2. Bit‑Flip Errors

The simplest error is a bit flip (Pauli‑X).
In this repo we model X errors as classical flips on binary arrays:
- X |0⟩ → |1⟩
- X |1⟩ → |0⟩

Independent X errors with probability $p$ are applied to physical qubits in Monte‑Carlo trials.

### 3. Three‑Qubit Repetition Code (classical picture)

Encode:
```
|0_L⟩ = |000⟩,  |1_L⟩ = |111⟩
```

The code corrects a single physical bit flip; two or more flips can produce a logical error.

### 4. Stabilizer / syndrome viewpoint (parity checks)

Parity checks $(Z_1 Z_2, Z_2 Z_3)$ produce syndrome bits that identify likely single‑qubit flips.
Syndrome patterns (signs or bit values) map to which physical qubit is most likely in error (conventions for sign/bit encoding vary and are implementation-dependent).
Measuring these parity operators reveals only parity information, not the logical amplitude.

### 5. Correction and Decoding

- Observe syndrome → apply corrective Pauli‑X on the inferred qubit → decode (majority vote).
- In this codebase decoding is implemented with simple majority-vote and block‑decoding heuristics (see src/).

### 6. Logical Error Rate

Let $p$ be the single‑qubit flip probability.
- No error: $(1−p)^3$
- Exactly one error (correctable): $3p(1−p)^2$
- Two or three errors (uncorrectable): $3p^2(1−p) + p^3$

So the logical failure rate for the 3‑qubit repetition code is:
```
P_fail = 3 p^2 (1 − p) + p^3
```
For small $p$ this scales as $O(p^2)$, showing suppression compared to a single physical qubit.

## References and further reading

- M. A. Nielsen and I. L. Chuang, "Quantum Computation and Quantum Information."
- D. Gottesman, "An introduction to quantum error correction and fault‑tolerant quantum computation."

---

📘 Author: Sid Richards (SidRichardsQuantum)

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" width="20" /> LinkedIn: https://www.linkedin.com/in/sid-richards-21374b30b/

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
