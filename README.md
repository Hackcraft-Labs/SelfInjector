# SelfInjector - Traditional Version

This repository accompanies the article [From traditional to templated malware](https://www.hackcraft.gr/2023/06/from-traditional-to-templated-malware/). It is a minimal example of a shellcode self-injector, which is offered as both a traditional static version (which you can find on the *traditional* branch) or a version templated with [Blueprint](https://github.com/Hackcraft-Labs/Blueprint) (which can be found on the *templated* branch).

## Disclaimer

Code in this repository is provided as an example use case and is not authored with OPSEC considerations in mind or to provide evasion. Simplicity is **HEAVILY** favored over the aforementioned principles and it should only serve as an example of Blueprint usage. 

More specifically, please keep in mind the following: 
- The original shellcode buffer is left uncleared after decryption, which exposes it in cleartext.
- The shellcode pages are allocated with `RWX` memory permissions.

## Community

Join the Hackcraft community discord server [here](https://discord.gg/KZZfsnQsja). On the server you can receive support and discuss issues related to SelfInjector.