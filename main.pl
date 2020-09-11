/* Fonctions utilitaires */

/* Assigne la première lettre d''une chaîne de caractères à la variable C. */
first_letter(S,C) :- sub_atom(S,0,1,_,C).

/* Détermine si le caractère C est en majuscule. */
upper_cased(C) :- upcase_atom(C,X), X==C.

/* Assigne la dernière lettre d'une chaîne de caractères à la variable C. */
last_letter(S,C) :- sub_atom(S,_,1,0,C).

/* Détermine si le caractère C est un point. */
is_comma(C) :- C=='.'.

/* Détermine si une chaîne de caractères S contient une sous-chaîne de caractères SS. */
is_substring(S,SS) :- sub_atom(S,_,_,_,SS), !.

/* 
    À partir d'une chaîne de caractères S contenant une sous-chaîne SS,
    extrait la chaîne B qui précède SS et la sous-chaîne A qui suit SS.
    
    Exemple:
    extract("abcdefg", "cd", B, A).

    B = "ab",
    A = "efg"
*/
extract(S,SS,B,A) :- sub_atom(S,Before,Len,After,SS), sub_atom(S,0,Before,_,B), X is Before+Len, sub_atom(S,X,After,_,A), !.

/*
    Enlève une sous-chaîne de caractères SS dans une chaîne S et assigne la chaîne résultante à la variable R.
    Si la sous-chaîne n'est pas contenue dans la chaîne S, R est égal à S.

    Exemple:
    remove("abcdefg", "c", R).

    R = "abdefg".
 */
remove(S,SS,R) :- (extract(S,SS,B,A), string_concat(B,A,R), !); R=S.

/* Détection d'erreurs */

/* Valide que la clause débute par une lettre minuscule. */
/* 1. On extrait la première lettre. */
/* 2. On vérifie si la première lettre est une majuscule. */
is_first_error(C) :- first_letter(C,F), upper_cased(F).

/* Valide que la clause se termine par un point. */
/* 1. On extrait la dernière lettre. */
/* 2. On vérifie si la dernière lettre n'est pas un point. */
is_second_error(C) :- last_letter(C,L), not(is_comma(L)).

/* Valide que la clause ne contient pas de parenthèse fermante précédée d'une virgule. */
/* 1. On vérifie si la clause contient la chaîne de caractères ',)'. */
is_third_error(C) :- is_substring(C,",)").

/* Valide que la clause ne contient pas deux virgules de suite. */
/* 1. On vérifie si la clause contient la chaîne de caractères ',,'. */
is_fourth_error(C) :- is_substring(C,",,").

/* Valide que la clause ne contient pas un commentaire incomplet. */
/* 1. On vérifie si la clause contient un début de commentaire seul. */
/* 1. On vérifie si la clause contient une fin de commentaire seule. */
is_fifth_error(C) :- ((is_substring(C,"/*"), not(is_substring(C,"*/")));(is_substring(C,"*/"), not(is_substring(C,"/*")))).

error(C,E) :- is_first_error(C), E = "La clause doit débuter par une lettre minuscule.".
error(C,E) :- is_second_error(C), E = "La clause doit se terminer par un point.".
error(C,E) :- is_third_error(C), E = "La clause contient une parenthèse fermante précédée d'une virgule.".
error(C,E) :- is_fourth_error(C), E = "La clause contient deux virgules de suite.".
error(C,E) :- is_fifth_error(C), E = "La clause contient un commentaire incomplet.".
/* Affiche un message par défaut si aucune des cinq erreurs n'a été détectée. */
error(_,E) :- E="Aucune erreur détectée.".

detecteur(C,E) :- error(C,E), !.

/* Correction d'erreurs */

/* Met la première lettre de la clause en minuscule. */
/* 1. On extrait la première lettre. */
/* 2. On extrait le reste de la chaîne de caractères. */
/* 3. On met la première lettre en minuscule. */
/* 4. On concatène la première lettre en minuscule avec le reste de la chaîne de caractères. */
correct(C,CC) :- is_first_error(C), first_letter(C,F), sub_atom(C,1,_,0,R), downcase_atom(F, FF), string_concat(FF,R,CC).
/* Ajoute un point à la fin de la clause. */
/* On concatène la chaîne de caractères et un point. */
correct(C,CC) :- is_second_error(C), string_concat(C,".",CC).
/* Enlève la virgule qui précède la parenthèse fermante. */
/* 1. On extrait les chaînes de caractères qui précèdent et suivent la chaîne ',)'. */
/* 2. On concatène la chaîne précédente avec le caractère ')'. */
/* 3. On concatène le résultat de l'étape 2 avec la chaîne suivante. */
correct(C,CC) :- is_third_error(C), extract(C,",)",B,A), string_concat(B,")",BB), string_concat(BB,A,CC).
/* Remplace deux virgules de suite par une seule. */
/* 1. On extrait les chaînes de caractères qui précèdent et suivent la chaîne ',,'. */
/* 2. On concatène la chaîne précédente avec le caractère ','. */
/* 3. On concatène le résultat de l'étape 2 avec la chaîne suivante. */
correct(C,CC) :- is_fourth_error(C), extract(C,",,",B,A), string_concat(B,",",BB), string_concat(BB,A,CC).
/* Retire un début ou fin de commentaire. */
/* 1. On retire un début de commentaire s'il y en a un. */
/* 2. On retire une fin de commentaire s'il y en a une. */
correct(C,CC) :- is_fifth_error(C), remove(C,"/*",R), remove(R,"*/",CC).

correcteur(C,CC) :- correct(C,CC), !.

/* Interface */

/* 
    Permet de saisir une clause C pour y détecter les erreurs. Si elle en contient au moins une,
    E contiendra le message d'erreur de la première erreur trouvée et CC contiendra la clause
    avec la correction apportée à la première erreur trouvée.
*/
saisie(C,E,CC) :- write('Veuillez saisir une clause:'), nl, read(C), detecteur(C,E), correcteur(C,CC).