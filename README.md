# IFT2003-TP3

## Erreurs choisies

1. La clause débute par une lettre majuscule.

```
Homme(gabriel). -> homme(gabriel).

Egaux(x,y). -> egaux(x,y).
```

2. La clause ne se termine pas par un point.

```
homme(gabriel) -> homme(gabriel).

egaux(x,y) -> egaux(x,y).
```

3. Une parenthèse fermante est précédée d'une virgule.
```
homme(gabriel) :- sexe(gabriel,M,). -> homme(gabriel) :- sexe(gabriel,M).

egaux(x,y) :- valeur(x,X,), valeur(y,X). -> egaux(x,y) :- valeur(x,X), valeur(y,X).
```

4. La clause contient deux virgules de suite.
```
valeur(x,,1). -> valeur(x,1).

egaux(x,y) :- valeur(x,X), valeur(y,,X). -> egaux(x,y) :- valeur(x,X), valeur(y,X).
```

5. La clause contient un commentaire incomplet
```
valeur(x/*,1). -> valeur(x,1).

egaux(x,y) :- valeur(x,X), valeur(y,X), */valeur(z,1). -> egaux(x,y) :- valeur(x,X), valeur(y,X), valeur(z,1).
```