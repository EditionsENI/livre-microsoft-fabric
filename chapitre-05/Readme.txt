Pour le chapitre 5 - Ingérer des données dans Fabric, vous aurez besoin de charger des fichiers depuis un compte de stockage Azure. 
Voici la procédure à suivre pour charger les fichiers source vers un nouveau container dans un compte de stockage Azure. 

Créer un compte de stockage Azure (Blob Storage)

	• Pour commencer, connectez-vous au Portail Azure (https://portal.azure.com) avec votre compte. 
	• Cherchez la section « Comptes de stockage » (ou utilisez le bouton Créer une ressource puis choisissez Stockage > Compte de stockage).
	• Cliquez sur « Créer » pour lancer la création d’un nouveau compte de stockage.
	• Dans l’onglet Basics (Bases), renseignez les informations essentielles : 
		○ le groupe de ressources (existant ou nouveau), 
		○ un Nom de compte unique (en minuscules, par ex. mystorageaccount), 
		○ la Région (emplacement du datacenter), 
		○ les performances (Standard recommandé) 
		○ et la redondance (par ex. local LRS)22. Laissez le Tier d’accès par défaut sur Hot (Actif) pour l’instant.
	• Cliquez sur « Review + create » (Vérifier + créer) en bas. 
	• Vérifiez le récapitulatif puis cliquez « Create ». 
	• Azure déploie alors le compte de stockage (quelques secondes).
	

Créer un conteneur Blob dans le compte de stockage

	• Une fois le compte de stockage prêt, il faut créer un conteneur pour y stocker les blobs (fichiers) :
	• Dans le portail Azure, accédez à votre compte de stockage récemment créé (via Accueil Azure > Comptes de stockage).
	• Dans le menu du compte, sous « Stockage des données », cliquez sur « Conteneurs ». 
	• Vous voyez la liste des conteneurs (vide pour un nouveau compte)
	• Cliquez sur « + Conteneur », puis donnez un nom au conteneur  : "wwi"
	• Laissez le niveau d’accès sur Privé (aucun accès anonyme).
	• Validez avec « Créer ». Le nouveau conteneur apparaît dans la liste.
	• Dans le container "wwi", cliquez sur "Ajouter un répertoire", puis entrez "wwicsvfiles".

Uploader les fichiers depuis le poste de travail (via le portail)

	• Assurez-vous d’avoir les fichiers CSV sur votre ordinateur. (Téléchargez-les depuis GitHub dans Chapitre-05/WWI/wwicsvfiles).
	• Dans le portail Azure, accédez au conteneur créé précédement. (Cliquez sur le nom du conteneur dans la liste des conteneurs.) 
	• Selectionnez ensuite le dossier "wwicsvfiles"
	• Cliquez sur le bouton « Charger » (Upload). Dans le volet qui s’ouvre, cliquez sur « Sélectionner un fichier » et parcourez votre disque pour choisir les fichiers CSV du dossier local. 
	• Cliquez sur « Charger » pour lancer l’upload. 
	• Vérifiez que chaque fichier apparaît dans la liste des blobs du conteneur une fois le transfert terminé.

Bonnes pratiques : Pensez à activer la suppression retenue (Soft Delete) sur vos blobs pour prévenir les effacements accidentels. 