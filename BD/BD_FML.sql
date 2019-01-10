/*Création de la BD CML*/
/*Créée le 29 décembre 2018*/

USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'CML_BD')
DROP DATABASE CML_BD

CREATE DATABASE CML_BD
GO
USE CML_BD
GO

--Fonction de l'utilisateur (surfaceur, standard)
CREATE TABLE T_FonctionUti(
	idFonction INT IDENTITY(1,1),
	nomFonction VARCHAR(30),
	CONSTRAINT pkidFonction PRIMARY KEY (idFonction)
)

--Utilisateur
CREATE TABLE T_Utilisateur(
	idUtilisateur INT IDENTITY(1,1),
	nomUtilisateur VARCHAR(30) NOT NULL,
	prenomUtilisateur VARCHAR(30) NOT NULL,
	pseudoUtilisateur VARCHAR(30) NOT NULL,
	motDePasse VARCHAR(30) NOT NULL,
	idFonction INT NOT NULL,
	CONSTRAINT pkIdUtilisateur PRIMARY KEY(idUtilisateur),
	CONSTRAINT fkIdFonction FOREIGN KEY (idFonction) REFERENCES T_FonctionUti(idFonction)
)

--Publication
CREATE TABLE T_Publication(
	idPublication INT IDENTITY(1,1),
	descriptionPublication VARCHAR(200),
	idUtilisateur INT NOT NULL,
	CONSTRAINT pkIdPub PRIMARY KEY(idPublication),
	CONSTRAINT fkidUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES T_Utilisateur(idUtilisateur)
)

--Une publication peut contenir des photos
CREATE TABLE T_Photo(
	idPhoto INT IDENTITY(1,1),
	photoPublication IMAGE,
	idPub INT NOT NULL,
	CONSTRAINT pkidPhoto PRIMARY KEY(idPhoto),
	CONSTRAINT fkIdPhoto FOREIGN KEY (idPub) REFERENCES T_Publication(idPublication)
)

--Une publication peut contenir des commentaires
CREATE TABLE T_COMMENTAIRE(
	idCommentaire INT IDENTITY(1,1),
	dateHeure DATETIME DEFAULT GETDATE(),
	descriptionCommentaire VARCHAR(100),
	idPubli INT NOT NULL,
	CONSTRAINT pkidCommentaire PRIMARY KEY(idCommentaire),
	CONSTRAINT fkidCommentaire FOREIGN KEY (idPubli) REFERENCES T_Publication(idPublication)
)

--Trail possible à surfacer
CREATE TABLE T_Trail(
	idTrail INT IDENTITY(1,1),
	nomTrail VARCHAR(30),
	CONSTRAINT pkidTrail PRIMARY KEY (idTrail)
)

--A chaque surfacage, le surfaceur devra l'inscrire
CREATE TABLE T_Surfacage(
	idSurfacage INT IDENTITY(1,1),
	dateHeure DATETIME DEFAULT GETDATE(),
	idTrail INT NOT NULL,
	nombreEssenceUtilise FLOAT(3),
	idSurfaceur INT NOT NULL,
	CONSTRAINT pkidSurfacage PRIMARY KEY (idSurfacage),
	CONSTRAINT fkidTrail FOREIGN KEY (idTrail) REFERENCES T_Trail(idTrail),
	CONSTRAINT fkidUtili FOREIGN KEY (idSurfaceur) REFERENCES T_Utilisateur(idUtilisateur)
)

--Fonction des Utilisateurs disponible
INSERT INTO T_FonctionUti(nomFonction) VALUES('Surfaceur')
INSERT INTO T_FonctionUti(nomFonction) VALUES('Standard')
INSERT INTO T_FonctionUti(nomFonction) VALUES('Admin')

--Trail possible qu'un surfaceur peut gratter
INSERT INTO T_Trail(nomTrail) VALUES('5')
INSERT INTO T_Trail(nomTrail) VALUES('35')

--Insertion du compte administrateur
INSERT INTO T_Utilisateur(nomUtilisateur, prenomUtilisateur, pseudoUtilisateur, motDePasse, idFonction) VALUES ('CML', 'CML', 'admin', 'admin', 3)
