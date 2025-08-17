% Apply independent bit-flip channel to a 3-qubit state vector
% Models noise by flipping each qubit with probability p
% (Simple Kraus-like mixture)

function psi_noisy = apply_bitflip_noise(psi,p)
[~,X,~,~] = pauli();
psi_noisy = 0;
for e0 = 0:1
  for e1 = 0:1
    for e2 = 0:1
      ops = { (e0==1)*X + (e0==0)*eye(2), ...
              (e1==1)*X + (e1==0)*eye(2), ...
              (e2==1)*X + (e2==0)*eye(2) };
      E = kronN(ops{:});
      k = e0+e1+e2;
      prob = (p^k)*((1-p)^(3-k));
      psi_noisy = psi_noisy + sqrt(prob)*(E*psi);
    end
  end
end
end
