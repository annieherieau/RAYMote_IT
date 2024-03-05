## 1. Présentation

**RAYMote IT** est une plateforme de e-learning innovante dédiée à l’informatique et à la technologie. Ce qui distingue **RAYMote IT** , c’est sa communauté d’apprenants actifs et engagés dans un environnement d’apprentissage collaboratif et dynamique.

Débutants cherchant à comprendre les fondamentaux, ou professionnels expérimentés, les utilisateurs peuvent proposer et s'inscrire à des ateliers en ligne, allant des bases de la programmation aux technologies avancées.

**RAYMote IT** : Revolutionize All Your Mastery

## 2. Parcours utilisateur 

- **Inscription et connexion** : L’utilisateur s’inscrit sur la plateforme et se connecte à son compte.
- **Découverte des ateliers disponibles** : L’utilisateur explore les ateliers disponibles sur la page d'accueil et peut afficher les détails. 
- **Inscription aux ateliers**: seuls les utilisateurs connectés peuvent s'inscrire aux ateliers gratuits ou payant via Stripe API.
- **Annulation des inscriptions aux ateliers**: les utilisateurs peuvent annuler leur inscription pour les ateliers gratuits. Pour les payants, ils sont invités à contacter un administrateur.
- **Proposition et vente d'ateliers**: les utilisateurs "créateurs" peuvent ajouter des cours en ligne de type ateliers, gratuits ou payants et les classer dans des catégories.
- **Dashboard utilisateur**: les utilisateurs peuvent consulter :
	 - la liste des ateliers auxquels ils participent
	 - gérer leur ateliers et consulter la liste des inscrits.
- **Interaction et communication**: les utilisateurs peuvent ajouter des commentaires et des like sur les ateliers.
- **Validation des ateliers** par un administrateur (modération)

## 3. Concrètement et techniquement

### 3.1. Base de données
- Base de Données Postgresql
- users, workshops, comments, likes, categories-tags, attendances
- admins, tables Active Storage

### 3.2. Front 
- Maquette Figma
- Design tech
- Bootstrap ou Tailwind

### 3.3. Backend  
- Paiement en ligne : API Stripe
- Gestions des users et admin : Devise
- Upload des images : Active storage
- Envoi des emails: API Mailjet
- Hébergement de production : Heroku
- Gestion des versions : Git / gitHub
- Rubocop

## 4. La version minimaliste MVP

- Index des ateliers à venir
- Inscription / connection des utilisateurs
- Création / modification des ateliers par leur créateur
- Inscription / désinscription aux ateliers
- Paiement en ligne
- Ajouts de commentaires / like sur les ateliers

## 5. La version présentée au jury

- Validation des ateliers par un administrateur
- Statut de l'atelier: brouillon, validé, refusé
- Ajout de photo : profil utilisateur, atelier
- Emails automatiques: création de compte, inscription, validation, etc
- Design Tech
- Formations en ligne: ressources payantes ou gratuites (lien vers la ressource)
- Mise en avant des ateliers/ formations les plus populaires

## 6. Notre mentor
Sacha GUILHAUMOU
