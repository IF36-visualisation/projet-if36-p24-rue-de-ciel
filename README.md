# **Percer les secrets du succès du film**

![dataset-cover](/Users/zkx/Downloads/dataset-cover.png)

### Membres :

- SHI Anhe
- JIAO Zihang
- ZHAO Biwei

- ZHANG Kaixuan

##  Analyse des données cinématographiques

### Contexte du jeu de données

Nous avons choisi le dataset "[The Ultimate Film Statistics Dataset - for ML](https://www.kaggle.com/datasets/alessandrolobello/the-ultimate-film-statistics-dataset-for-ml)" disponible sur Kaggle parce que les données du dataset sont **riches** et **proviennent d'un large éventail de sources**.

Ce dataset fournit des statistiques complètes sur les films, compilées à partir de plusieurs sources, notamment Wikipedia, The Numbers et IMDb. Les données ont été recoupées à plusieurs reprises afin de garantir la fiabilité et l'exactitude de l'ensemble des données.

Ce dataset offre aussi une riche collection d'informations et d'aperçus sur divers aspects des films, il permet à nous d'analyser et d'explorer les tendances de l'industrie cinématographique, d'évaluer le succès financier des films, d'identifier les genres populaires et d'étudier la relation entre les taux d'audience moyens et les résultats au box-office. Ce dataset nous permet d'explorer les multiples facettes du cinéma américain.

C'est le dataset avec lequel nous voulions **initialement travailler**.

En complément, le dataset "[IMDb India Movies](https://www.kaggle.com/datasets/adrianmcmahon/imdb-india-movies)" nous offre une perspective additionnelle, servant de point de comparaison pour identifier les spécificités et les tendances propres aux films indiens par rapport à leurs homologues américains.

Nous avons donc choisi le dataset de films indiens comme **support de travail**.

---

### **Données**

#### Données 1（**The Ultimate Film Statistics Dataset**）:

Cet ensemble de données fournit des statistiques cinématographiques complètes pour les États-Unis, compilées à partir de plusieurs sources, dont Wikipedia, The Numbers et IMDb. Il fournit une multitude d'informations et d'aperçus sur divers aspects du film tels que le titre, la date de production, le genre, la durée, les informations sur le réalisateur, la note moyenne, les ventes de billets, l'indice de soutien, le budget de production, le produit intérieur brut et le produit mondial brut.

Le jeu comporte **14 colonnes** et **4241 lignes**.

<u>Colonnes de données</u> :

| Caractéristiques      | Descriptions                                                 | Type                        |
| --------------------- | ------------------------------------------------------------ | --------------------------- |
| Movie_title           | *Le titre du film.*                                          | `String`                    |
| Production_date       | *la date de production du film*.                             | `DATE` (YYYY-MM-DD)         |
| Genres                | *Les genres de films.*                                       | `String`                    |
| Runtime_minutes       | *La durée du film en minutes.*                               | `float`                     |
| primaryName           | *Le nom et le prénom du directeur.*                          | `String`                    |
| primaryProfession     | *Les rôles du réalisateur dans le film.*                     | `String`                    |
| Director_birthYear    | *L'année de naissance du directeur.*                         | `DATE` (YYYY)               |
| Director_deathYear    | *L'année de décès du directeur.*                             | `String` ：'alive' / 'YYYY' |
| Movie_averageRating   | *Il s'agit de la note moyenne attribuée par les utilisateurs en ligne à un film donné.* | `float`                     |
| Movie_numberOfVotes   | *Il s'agit du nombre de votes donnés par les utilisateurs en ligne pour un film particulier.* | `float`                     |
| Approval_Index        | *Il s'agit d'un indicateur normalisé (sur une échelle de 0 à 10) . Il fournit une mesure de la popularité et de l'approbation globales d'un film parmi les spectateurs en ligne.* | `float`                     |
| Production_budget ($) | *Budget global de production du film.*                       | `Integer`                   |
| Domestic_gross ($)    | *Recettes intérieures brutes du film.*                       | `Integer`                   |
| Worldwide_gross ($)   | *Recettes brutes internationales des films.*                 | `Integer`                   |



#### Données 2（**IMDb India Movies**）:

Ce jeu de données contient des informations sur tous les films indiens répertoriés sur la plateforme IMDb.com, y compris le titre du film, l'année de sortie, la durée, le genre, la note du film et les recettes au box-office, etc. Le jeu de données comprend 10 lignes et 13828 entrées.

Colonnes de données：

| Caractéristiques | Descriptions                             | Type          |
| ---------------- | ---------------------------------------- | ------------- |
| Name             | *Le nom du film.*                        | `String`      |
| Year             | *L'année de sortie du film.*             | `Date` (YYYY) |
| Duration         | *La durée du film en minutes.*           | `float`       |
| Genre            | *Le genre du film.*                      | `String`      |
| Rating           | *L'évaluation attribuée au film.*        | `float`       |
| Votes            | *Le nombre de votes attribués au film.*  | `Integer`     |
| Director         | *Le réalisateur du film.*                | `String`      |
| Actor 1          | *Le premier acteur principal du film.*   | `String`      |
| Actor 2          | *Le deuxième acteur principal du film.*  | `String`      |
| Actor 3          | *Le troisième acteur principal du film.* | `String`      |



---

### **Analyse des données**

 L'ensemble de données que nous avons choisi, "The Ultimate Film Statistics Dataset - for ML", est très riche en contenu. C'est également l'ensemble de données avec lequel nous voulions initialement travailler.

 Avant de poursuivre l'analyse, nous avons d'abord examiné de manière générale certaines caractéristiques des données :

1. Nous avons constaté que les films de l'ensemble de données étaient tous des films américains.
2. L'âge des films s'étend de 1915 à 2023, mais la plupart des données se concentrent sur la période 1980-2023.
3. Nous avons remarqué que les catégories de films étaient particulièrement riches en DRAMA, ce qui pourrait affecter les analyses ultérieures.
4. La durée des films est concentrée entre 83 minutes et 146 minutes.
5. Nous remarquons qu'il y a beaucoup de films de Steven Spielberg dans l'ensemble de données, ce qui peut affecter l'analyse ultérieure.
6. La catégorie de film et la profession du réalisateur sont toutes deux composées de trois mots différents, mais l'ordre de préséance différent peut conduire à considérer des combinaisons telles que ABC et CAB comme des catégories différentes.
7. Nous constatons qu'il existe de nombreuses valeurs nulles pour les heures de naissance et de décès du réalisateur
8. Les notes des films sont regroupées entre 5,4 et 7,74.

 À la suggestion du professeur, nous avons trouvé un autre ensemble de données "IMDb India Movies". Les données de ce jeu de données concernent les films indiens, mais le jeu de données n'est pas aussi riche que le premier jeu de données. 

 Avant de procéder à l'analyse, nous avons également observé les caractéristiques de cet ensemble de données :

1. Nous avons constaté que tous les films de l'ensemble de données sont des films indiens.
2. Il y a une valeur nulle de 53 % dans la durée des films, nous devons donc être prudents dans l'utilisation de cette métrique lors de l'analyse et réfléchir à la manière de la traiter correctement.
3. L'ensemble de données contient des données relatives aux acteurs, mais il est difficile d'établir un lien avec le premier ensemble de données principal analysé.

 Nous avons donc pensé que nous pourrions examiner les questions suivantes:

**1. Analyse du box-office :** Il s'agit d'une analyse classique liée au cinéma. Nous voulons trouver les facteurs qui influencent le box-office, ce qui peut révéler quels facteurs ont le plus grand impact sur le succès commercial d'un film et aider les producteurs, les distributeurs et les investisseurs à prendre des décisions plus éclairées.

Nous avons décidé de nous concentrer sur d'autres indicateurs avec la corrélation "Domestic_gross ($)" , "Worldwide_gross ($)". et de les comparer sur la base de ces deux indicateurs. Bien entendu, tous les indicateurs n'ont pas un lien explicable avec ces deux indicateurs, par exemple, le lien entre l'année de naissance du directeur et ces deux indicateurs est difficile à expliquer, et même s'il est prouvé qu'il existe une corrélation entre eux par des méthodes statistiques, nous éliminons l'influence de ces indicateurs sur les résultats qui sont difficiles à prouver en termes de causalité.

Nous trouverons les facteurs qui influencent le plus les indicateurs liés au box-office.

En termes de visualisation, nous voulons montrer les **corrélations** et les **comparaisons** entre les données.

**2. Analyse du genre** : il s'agit là encore d'une analyse classique pour les ensembles de données cinématographiques.

Contrairement à l'analyse du box-office, nous n'examinerons que l'impact du genre du film sur sa performance. Les mesures liées à la performance d'un film sont "Movie_averageRating", "Movie_numberOf Votes", "Approval_Index", "Domestic_Index" et "Movie_NumberOfVotes". Index", "Domestic_Gross", "Worldwide_gross". Ces indicateurs mesurent la performance d'un film après sa sortie sous différents angles et seront pris en compte ensemble dans notre analyse.

Nous utiliserons une combinaison de critères pour déterminer les catégories de films les plus performants.

En termes de visualisation, nous voulons montrer des **comparaisons** et des **décompositions** entre les données.

**3 Analyse du classement :** dans le prolongement de la question précédente, nous avons constaté qu'il pouvait y avoir des corrélations et des effets entre les mesures de la performance des films elles-mêmes. Nous n'étudierons donc pas l'impact des attributs du film sur la note dans cette question.

Plus intéressant, nous explorerons la relation entre la note moyenne, le nombre de votes et le succès financier (box-office, bénéfices).

Les notes ne sont pas nécessairement en corrélation positive avec la capacité d'un film à gagner de l'argent, et nous explorerons la relation entre les notes et le succès financier d'un film sur la base de notre ensemble de données. Il peut s'agir d'une caractéristique basée sur notre ensemble de données et non d'une conclusion directe que l'on peut trouver sur le web.

En termes de visualisation, nous montrerons la **corrélation** entre les données.



**4 Analyse des réalisateurs :** il existe de nombreuses colonnes sur les réalisateurs dans notre ensemble de données. Sur la base de ces données, nous souhaitons étudier les caractéristiques des réalisateurs qui font de bons films.

Les critères d'un bon film sont les mêmes que ceux de la question étudiée ci-dessus, à savoir une combinaison de l'évaluation, du nombre de votants, du box-office et des bénéfices.

Dans les colonnes relatives au réalisateur, nous pouvons obtenir l'âge du réalisateur, sa profession, s'il est vivant ou non, et d'autres caractéristiques. Nous voulons savoir s'il existe des points communs entre ces réalisateurs qui font de bons films.

En termes de visualisation, nous voulons montrer la **corrélation** entre les données

**5 Analyse du temps :** Chaque génération a sa propre culture. Les revenus et les préférences des gens changent selon les époques.

Nous voulons donc étudier la tendance des films au cours des différentes années de production et observer les changements dans les budgets de production, les recettes au box-office et les préférences en matière de genre.

L'objectif de cette question est clair, il s'agit en fait de l'impact de l'âge du film sur d'autres indicateurs.

En termes de visualisation, nous voulons montrer des **comparaisons** et des évolutions entre les données.

**6 Analyse du pays** : 

Nous pouvons tout de même étudier les questions 2 et 5 ci-dessus sur ensemble de données "IMDb India Movies". Mais ce qui est plus intéressant, c'est qu'avec cet ensemble de données, nous disposons d'une dimension supplémentaire de pays.

Grâce à cette dimension, nous pouvons comparer les préférences cinématographiques de deux pays, l'Inde et les États-Unis. Il est également possible de comparer le marché de l'industrie cinématographique (par le biais du nombre de films) à différentes époques dans les deux pays.

En termes de visualisation, nous voulions montrer des **comparaisons** entre les données à travers la dimension du pays, et des **évolutions** en fonction de la chronologie.