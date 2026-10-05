# CA ase-studio

This repo contains exercises from my Computer Architectures class, in RISC-V assembly.
The environment is [gem5](https://www.gem5.org/) with the [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain).

## Patches

Polito developed some internal packages based on the tools above. Namely:
- [ASE Studio](https://github.com/cad-polito-it/ase-studio);
- A compatible [fork of gem5](https://github.com/cad-polito-it/gem5);
- The [ase_riscv_gem5_sim](https://github.com/cad-polito-it/ase_riscv_gem5_sim) project (which bundles some of the above).

I had to make a few changes to get this running on my machine (OS is Arch Linux).
The main problem is that it's quite hard to get Python 3.10 running stable on a rolling release distro.
The solution is a bit ugly, but:
- `libs` contains some `.so`s the fork of gem5 links to;
- `patches` contains patches of ASE Studio made to work with said libs.

One should ideally copy `libs` above the ASE Studio installation, and the contents of `patches` directly inside the ASE studio installation.
A better solution is likely to use a Docker or a VM.
Please contact anyone else before me if you have issues, as I barely have any idea of what I'm doing.
