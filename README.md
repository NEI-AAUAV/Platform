# NEI-AAUAv Platform

**[NEI Platform Documentation](https://nei-aauav.github.io/Platform-Documentation)**

## Quick Start

### Running the Platform

```bash
# Start all services
docker-compose up -d

# Start with specific extensions (see EXTENSIONS.md for details)
echo "ENABLED_EXTENSIONS=rally" > .env
docker-compose up -d --build api_nei
```

### Extension Control

See [EXTENSIONS.md](./EXTENSIONS.md) for detailed information on how to control which extensions are loaded.

**Quick Examples:**
- **No extensions**: `ENABLED_EXTENSIONS=` or no `.env` file
- **Rally only**: `ENABLED_EXTENSIONS=rally`
- **Multiple extensions**: `ENABLED_EXTENSIONS=rally,gala`

## Contributors

**2021 Mandate**

Vogal:
[Gonçalo Matos](https://github.com/gmatosferreira) gmatosferreira

<details open>
<summary>Collaborators:</summary>

- [Diogo Monteiro](https://github.com/diomont) diomont
- [Fábio Martins](https://github.com/fMart8421) fMart8421
- [Lucius Vinicius](https://github.com/luciusvinicius) luciusvinicius
- [Pedro Duarte](https://github.com/PedroDuarte536) PedroDuarte536
</details>

**2022 Mandate (Semester 1)**

Vogal:
[Leandro Silva](https://github.com/leand12) leand12

<details open>
<summary>Collaborators:</summary>

- [Alexandre Cotorobai](https://github.com/AlexandreCotorobai) AlexandreCotorobai
- [Bernardo Figueiredo](https://github.com/LeikRad) LeikRad
- [Daniel Madureira](https://github.com/Dan1m4D) Dan1m4D
- [Diana Miranda](https://github.com/dianarrmiranda) dianarrmiranda
- [Eduardo Fernandes](https://github.com/eduardofernandes11) eduardofernandes11
- [João Luís](https://github.com/jnluis) jnluis
- [José Gameiro](https://github.com/zegameiro) zegameiro
- [Pedro Monteiro](https://github.com/pedromonteiro01) pedromonteiro01
</details>

**2022 Mandate**

Vogal:
[Leandro Silva](https://github.com/leand12) leand12

<details open>
<summary>Collaborators:</summary>

- [Alexandre Cotorobai](https://github.com/AlexandreCotorobai) AlexandreCotorobai
- [Bárbara Galiza](https://github.com/Barb02) Barb02
- [Bernardo Figueiredo](https://github.com/LeikRad) LeikRad
- [Dani Figueiredo](https://github.com/daniff15) daniff15
- [Daniel Madureira](https://github.com/Dan1m4D) Dan1m4D
- [Diana Miranda](https://github.com/dianarrmiranda) dianarrmiranda
- [Eduardo Fernandes](https://github.com/eduardofernandes11) eduardofernandes11
- [Guilherme Rosa](https://github.com/guilherme096) guilherme096
- [João Capucho](https://github.com/JCapucho) JCapucho
- [João Luís](https://github.com/jnluis) jnluis
- [José Gameiro](https://github.com/zegameiro) zegameiro
- [Pedro Monteiro](https://github.com/pedromonteiro01) pedromonteiro01
- [Tomás Victal](https://github.com/fungame2270) fungame2270
- [Zakhar Kruptsala](https://github.com/Blosuhm) Blosuhm
</details>
