## 1. Présentation

**RAYMote IT** est une plateforme de e-learning innovante dédiée à l’informatique et à la technologie. Ce qui distingue **RAYMote IT** , c’est sa communauté d’apprenants actifs et engagés dans un environnement d’apprentissage collaboratif et dynamique.

Débutants cherchant à comprendre les fondamentaux, ou professionnels expérimentés, les utilisateurs peuvent proposer et s'inscrire à des ateliers en ligne, allant des bases de la programmation aux technologies avancées.

**RAYMote IT** : Revolutionize All Your Mastery (Révolutionnez votre maîtrise)

**La team RAYM** : [Robena](https://github.com/Robe-Ras), [Annie](https://github.com/annieherieau), [Yann](https://github.com/YannRZG) et [Malo](https://github.com/Korblen)

**Notre mentor** : Sacha GUILHAUMOU

## 2. Démos 
- Version MVP : https://raymote-it-mvp.fly.dev/
- Version présentée au jury : https://raymote-it-dev.fly.dev/

## 3. Parcours utilisateur 

- **Découverte des ateliers disponibles** : Le visiteur explore les ateliers Live et cours disponibles sur la page d'accueil et peut afficher les détails. Ces ressources peuvent être gratruites ou payantes.
- **Inscription et connexion** : Le visiteur doit s’inscrire sur la plateforme et être connecté à son compte pour pouvoir s'incrire aux ateliers et cours. (+ email de bienvenue)
- **Inscription aux ateliers**: Les utilisateurs connectés peuvent s'inscrire aux ateliers/cours gratuits ou payants via Stripe (+ email de confirmation de commande)
- **Interaction et communication**: les utilisateurs peuvent liker les ressources et noter les ateliers/cours auxquels ils sont inscrits.
- **Annulation des inscriptions**: les utilisateurs peuvent annuler leur inscription pour les ateliers gratuits. Pour les payants, ils sont invités à contacter un administrateur.
- **Proposition et vente d'ateliers**: les utilisateurs peuvent demander à avoir un compte "Créateur". Cette demande à soumise à validation des administrateurs. Avec ce nouveau statut, les Créateurs lpeuvent partager des ressources sur la plateforme. La publication des cours et ateliers est également soumise à validation des administrateurs.
- **Dashboard utilisateur/créateur**: les utilisateurs peuvent  :
	 - consulter la liste de leurs inscription, commandes, avis
	 - faire de demande de compte créateur (par messagerie interne)
	 - gérer leur ateliers et consulter la liste des inscrits (créateur)
	 - modifier leurs paramètres d'affichage (contratste élévé, police Opendys)
	 - modifier leur données personnelles (+ photo) et de connexion
	 - messagerie : réception des demandes des candidatures
- **Dashboard Administrateur** :
	 - validation / refus des demandes des candidatures "Créateur"
	 - validation / refus des demandes de publication
	 - suppression des utilisateurs
	 - messagerie : réception des demandes des candidatures

## 4. Stack et Installation

### 4.1 Stack
- Ruby 3.2.2
- Rails 7.1.3.2
- APIs:
    - Stripe : paiement en ligne sécurisé
    - Mailjet : envoi des emails
    - Youtube : pour alimenter la base de données pour la démo
    - Cloudinary : stokage en ligne

### 4.2 Installation

Clone repository

Install dépendencies

```bash
bundle install
```
Precompile Assets

```bash
bundle exec rake assets:precompile
```

Database

```bash
rails db:create
rails db:migrate
```

Launch server

```bash
rails server
```
