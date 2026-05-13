# Theory: Quantum Error Correction (QEC)

Important note about the implementation
- This repository uses pure state vectors and projective stabilizer measurements for small educational QEC codes.
- It does not simulate density matrices, coherent non-Pauli noise channels, full syndrome-extraction circuits, or fault-tolerant gates.
- Monte Carlo examples still focus on independent Pauli-X bit-flip noise for the 3-qubit repetition code.

### 1. Why Error Correction?

Quantum bits (qubits) are fragile: interaction with the environment (decoherence) or imperfect control operations cause errors.
Because qubits cannot be cloned, redundancy and indirect (syndrome) measurements are used to detect and correct errors without destroying logical information.

### 2. Pauli Errors

The simplest error is a bit flip (Pauli-X).
For the 3-qubit Monte Carlo examples, independent X errors are sampled with probability $p$:
- X |0⟩ → |1⟩
- X |1⟩ → |0⟩

The phase-flip, Shor, Steane, and 5-qubit helpers apply explicit Pauli strings to state vectors and recover from single-qubit Pauli errors.
The depolarizing examples sample independent X/Y/Z errors with equal probability after an error event.

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

- Observe syndrome → apply the corresponding Pauli correction.
- `recover_*` functions preserve the encoded logical state up to global phase for correctable errors.
- `decode_majority` is still available for the classical readout demo of the 3-qubit bit-flip code.

### 6. Additional Codes

- 3-qubit phase-flip code: protects against one Z error by encoding in the X basis and measuring X-parity checks.
- 9-qubit Shor code: concatenates phase and bit repetition structure and corrects any single-qubit Pauli error.
- 5-qubit perfect code: smallest distance-3 stabilizer code, using four generators and a syndrome lookup table.
- 7-qubit Steane code: CSS code using Hamming-code parity checks; X and Z syndromes identify the affected qubit.
- 1D repetition decoder: chooses the minimum-weight error chain compatible with a measured parity syndrome.
- Small surface-code prototype: a 3x3 rotated-layout X-error model using Z-check syndromes and a cached minimum-weight matching-style lookup.

### 7. Noisy Syndrome Measurements

The bit-flip noisy-syndrome example repeats syndrome extraction and majority-votes each syndrome bit.
This models classical measurement readout errors on the reported syndrome bits, not a full ancilla-based circuit with hook errors or data errors between rounds.

### 8. Logical Error Rate

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

This project is licensed under the MIT License - see [../LICENSE](../LICENSE).
