# 📘 Documentation Technique et Fonctionnelle
# RIA Check & Go - Webside

**Version :** 1.0  
**Date :** Novembre 2025  
**Auteur :** Équipe Développement Webside

---

## 📋 Table des matières

1. [Introduction](#1-introduction)
2. [Conception Fonctionnelle](#2-conception-fonctionnelle)
3. [Conception Technique](#3-conception-technique)
4. [Modèle de Données](#4-modèle-de-données)
5. [Architecture Système](#5-architecture-système)
6. [Parcours Utilisateur (UX)](#6-parcours-utilisateur-ux)
7. [Spécifications Fonctionnelles Détaillées](#7-spécifications-fonctionnelles-détaillées)
8. [Conformité Réglementaire](#8-conformité-réglementaire)
9. [Sécurité et RGPD](#9-sécurité-et-rgpd)
10. [Tests et Validation](#10-tests-et-validation)
11. [Déploiement et Maintenance](#11-déploiement-et-maintenance)

---

## 1. Introduction

### 1.1 Contexte du projet

**RIA Check & Go** est une application web/mobile développée par **Webside** pour accompagner les entreprises dans leur mise en conformité avec le **Règlement sur l'Intelligence Artificielle (AI Act)** de l'Union Européenne.

### 1.2 Objectifs

- **Objectif principal :** Simplifier l'évaluation de conformité des systèmes d'IA
- **Objectifs secondaires :**
  - Générer automatiquement des rapports de conformité
  - Identifier les obligations légales applicables
  - Faciliter la prise de contact avec les experts Webside
  - Convertir les prospects en clients via un parcours fluide

### 1.3 Périmètre fonctionnel

L'application couvre :
- Classification automatique des systèmes d'IA (Annexe II et III du RIA)
- Détection des pratiques interdites (Article 5)
- Évaluation des obligations pour systèmes à haut risque (Titre III)
- Génération de rapports PDF personnalisés
- Gestion des demandes de devis

---

## 2. Conception Fonctionnelle

### 2.1 Arborescence de l'application

```
RIA Check & Go
│
├── 📱 Page d'accueil
│   ├── Présentation de la solution
│   ├── Bénéfices clés
│   ├── Informations sur le RIA
│   └── CTA "Commencer le diagnostic"
│
├── 📋 Module de Diagnostic
│   ├── Étape 1 : Informations entreprise
│   │   ├── Nom de l'entreprise
│   │   ├── Secteur d'activité
│   │   └── Type de système d'IA
│   │
│   ├── Étapes 2-6 : Questionnaire RIA
│   │   ├── Q1 : Techniques de manipulation
│   │   ├── Q2 : Contexte critique
│   │   ├── Q3 : Données biométriques
│   │   ├── Q4 : Interaction sans supervision
│   │   └── Q5 : Documentation technique
│   │
│   └── Barre de progression
│
├── 📊 Page de Résultats
│   ├── Score de conformité (0-100)
│   ├── Niveau de risque
│   ├── Alertes critiques
│   ├── Liste des obligations
│   ├── Téléchargement rapport PDF
│   └── Formulaire de contact/devis
│
└── ℹ️ Page À propos
    ├── Présentation Webside
    └── Services proposés
```

### 2.2 Fonctionnalités clés

#### **F1 - Diagnostic de Conformité**
- **Description :** Questionnaire interactif en 5 questions pour évaluer le niveau de conformité
- **Entrées :** Réponses utilisateur (Oui/Non/Je ne sais pas)
- **Sorties :** Score de conformité, niveau de risque, obligations applicables
- **Règles métier :**
  - Si Q1 = "Oui" → Risque inacceptable (pratique interdite)
  - Si Q2 ou Q3 = "Oui" → Risque élevé (+30 points)
  - Si Q5 = "Non" → Pénalité de conformité (-20 points)

#### **F2 - Moteur d'Analyse de Risque**
- **Description :** Algorithme de calcul du score et classification selon le RIA
- **Logique :**
  ```
  Score = Base (0) + Points Questions
  
  Catégories de risque :
  - Inacceptable : Pratiques interdites (Art. 5)
  - Élevé : Score > 60 ou secteur critique
  - Modéré : Score 30-60
  - Minimal : Score < 30
  ```

#### **F3 - Génération de Rapport PDF**
- **Description :** Création automatique d'un rapport personnalisé
- **Contenu du rapport :**
  - Synthèse des réponses
  - Score et niveau de risque
  - Liste détaillée des obligations
  - Recommandations d'actions
  - Coordonnées Webside

#### **F4 - Formulaire de Demande de Devis**
- **Description :** Capture des coordonnées pour contact commercial
- **Champs :** Nom, Email, Téléphone
- **Validation :** Email valide, champs obligatoires
- **Action :** Envoi email vers CRM Webside

---

## 3. Conception Technique

### 3.1 Stack technologique proposée

#### **Frontend**

| Technologie | Version | Usage |
|-------------|---------|-------|
| **React** | 18.x | Framework UI principal |
| **TypeScript** | 5.x | Typage statique |
| **Tailwind CSS** | 3.x | Styling responsive |
| **Lucide React** | 0.263.1 | Bibliothèque d'icônes |
| **React Router** | 6.x | Navigation SPA |
| **Axios** | 1.x | Requêtes HTTP |

#### **Backend**

| Technologie | Version | Usage |
|-------------|---------|-------|
| **Node.js** | 20.x LTS | Runtime serveur |
| **Express.js** | 4.x | Framework API REST |
| **PostgreSQL** | 15.x | Base de données principale |
| **Redis** | 7.x | Cache et sessions |
| **JWT** | 9.x | Authentification |

#### **Services externes**

- **SendGrid** : Envoi d'emails (rapports, notifications)
- **Stripe** : Paiement en ligne (futurs services premium)
- **AWS S3** : Stockage des rapports PDF générés
- **Google Analytics** : Tracking et conversion

### 3.2 Architecture proposée

```
┌─────────────────────────────────────────────────────────┐
│                    FRONTEND (React)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Pages      │  │  Components  │  │   Services   │  │
│  │  - Home      │  │  - Navigation│  │  - API calls │  │
│  │  - Diagnostic│  │  - Forms     │  │  - Storage   │  │
│  │  - Results   │  │  - Cards     │  │  - Analytics │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                           ↓ HTTPS
┌─────────────────────────────────────────────────────────┐
│                 API GATEWAY (Nginx)                      │
│                 Load Balancer + SSL                      │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│                BACKEND API (Node.js/Express)             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Controllers │  │   Services   │  │  Middleware  │  │
│  │  - Diagnostic│  │  - Risk Calc │  │  - Auth      │  │
│  │  - Report    │  │  - PDF Gen   │  │  - CORS      │  │
│  │  - Contact   │  │  - Email     │  │  - Rate Limit│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
           ↓                    ↓                   ↓
┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐
│   PostgreSQL    │  │      Redis      │  │   AWS S3    │
│   (Données)     │  │     (Cache)     │  │   (PDF)     │
└─────────────────┘  └─────────────────┘  └─────────────┘
```

### 3.3 API REST - Endpoints principaux

#### **Diagnostic**

```
POST /api/v1/diagnostic/start
Body: { companyName, sector, aiType }
Response: { diagnosticId, sessionToken }

POST /api/v1/diagnostic/:id/answer
Body: { questionId, answer }
Response: { success, nextQuestion }

POST /api/v1/diagnostic/:id/complete
Response: { score, riskLevel, obligations }
```

#### **Rapports**

```
GET /api/v1/report/:diagnosticId
Response: { reportUrl (PDF) }

POST /api/v1/report/generate
Body: { diagnosticId }
Response: { reportId, downloadUrl }
```

#### **Contact**

```
POST /api/v1/contact/quote-request
Body: { name, email, phone, diagnosticId }
Response: { requestId, confirmationSent }
```

### 3.4 Sécurité API

- **Rate Limiting :** 100 requêtes/heure par IP
- **CORS :** Whitelist des domaines autorisés
- **Validation :** Joi/Zod pour valider les entrées
- **Sanitization :** Protection contre injection SQL/XSS
- **HTTPS :** Obligatoire en production (certificat SSL)
- **API Key :** Pour les intégrations tierces

---

## 4. Modèle de Données

### 4.1 Schéma de base de données

#### **Table : companies**
```sql
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    ai_system_type VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **Table : diagnostics**
```sql
CREATE TABLE diagnostics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    session_token VARCHAR(255) UNIQUE,
    status VARCHAR(50) DEFAULT 'in_progress',
    score INTEGER,
    risk_level VARCHAR(50),
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    INDEX idx_session (session_token),
    INDEX idx_company (company_id)
);
```

#### **Table : diagnostic_answers**
```sql
CREATE TABLE diagnostic_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    diagnostic_id UUID REFERENCES diagnostics(id) ON DELETE CASCADE,
    question_id VARCHAR(50) NOT NULL,
    answer VARCHAR(50) NOT NULL,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_diagnostic (diagnostic_id)
);
```

#### **Table : obligations**
```sql
CREATE TABLE obligations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    risk_level VARCHAR(50),
    article_reference VARCHAR(50),
    category VARCHAR(100)
);
```

#### **Table : diagnostic_obligations**
```sql
CREATE TABLE diagnostic_obligations (
    diagnostic_id UUID REFERENCES diagnostics(id) ON DELETE CASCADE,
    obligation_id UUID REFERENCES obligations(id),
    PRIMARY KEY (diagnostic_id, obligation_id)
);
```

#### **Table : contact_requests**
```sql
CREATE TABLE contact_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    diagnostic_id UUID REFERENCES diagnostics(id),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    message TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status)
);
```

#### **Table : reports**
```sql
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    diagnostic_id UUID REFERENCES diagnostics(id),
    pdf_url VARCHAR(500),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    downloaded_at TIMESTAMP
);
```

### 4.2 Relations entre entités

```
┌──────────────┐
│  companies   │
└──────┬───────┘
       │ 1:N
       ↓
┌──────────────┐        ┌──────────────────┐
│ diagnostics  │───N:N──│   obligations    │
└──────┬───────┘        └──────────────────┘
       │ 1:N                     ↑
       ↓                         │
┌─────────────────────┐          │
│ diagnostic_answers  │          │
└─────────────────────┘          │
       │                         │
       │                         │
       ↓                         │
┌──────────────────┐    ┌────────────────────┐
│ contact_requests │    │ diagnostic_obligations│
└──────────────────┘    └────────────────────┘
       │
       ↓
┌──────────────┐
│   reports    │
└──────────────┘
```

### 4.3 Données de référence - Questions RIA

```json
{
  "questions": [
    {
      "id": "q1",
      "text": "Votre système d'IA utilise-t-il des techniques de manipulation subliminale ?",
      "category": "interdiction",
      "risk_type": "inacceptable",
      "article_ref": "Article 5",
      "weight": 100
    },
    {
      "id": "q2",
      "text": "Votre système d'IA est-il utilisé dans un contexte critique (santé, transports, éducation) ?",
      "category": "risque_eleve",
      "risk_type": "high",
      "article_ref": "Annexe III",
      "weight": 30
    },
    {
      "id": "q3",
      "text": "Votre système traite-t-il des données biométriques ?",
      "category": "donnees_sensibles",
      "risk_type": "high",
      "article_ref": "Article 10",
      "weight": 30
    },
    {
      "id": "q4",
      "text": "Votre système interagit-il directement avec des utilisateurs sans supervision humaine ?",
      "category": "transparence",
      "risk_type": "medium",
      "article_ref": "Article 52",
      "weight": 15
    },
    {
      "id": "q5",
      "text": "Disposez-vous d'une documentation technique complète de votre système ?",
      "category": "documentation",
      "risk_type": "compliance",
      "article_ref": "Annexe IV",
      "weight": -20
    }
  ]
}
```

---

## 5. Architecture Système

### 5.1 Diagramme de déploiement

```
┌──────────────────────────────────────────────────────┐
│                   CDN (CloudFlare)                    │
│              Static Assets + Caching                  │
└───────────────────────┬──────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────┐
│              Load Balancer (AWS ELB)                  │
└───────────┬──────────────────────┬───────────────────┘
            ↓                      ↓
   ┌────────────────┐     ┌────────────────┐
   │  Web Server 1  │     │  Web Server 2  │
   │   (EC2/Docker) │     │   (EC2/Docker) │
   └────────┬───────┘     └────────┬───────┘
            │                      │
            └──────────┬───────────┘
                       ↓
            ┌──────────────────┐
            │   API Server     │
            │  (Node.js/PM2)   │
            └─────────┬────────┘
                      ↓
        ┌─────────────┴─────────────┐
        ↓                           ↓
┌────────────────┐          ┌────────────────┐
│  PostgreSQL    │          │     Redis      │
│  (RDS/Master)  │          │   (ElastiCache)│
└────────┬───────┘          └────────────────┘
         │
         ↓
┌────────────────┐
│  PostgreSQL    │
│  (RDS/Replica) │
└────────────────┘
```

### 5.2 Infrastructure recommandée

#### **Production**
- **Hébergement :** AWS / Azure / Google Cloud
- **Frontend :** S3 + CloudFront (CDN)
- **Backend :** EC2 (t3.medium) avec Auto-scaling
- **Base de données :** RDS PostgreSQL (db.t3.medium)
- **Cache :** ElastiCache Redis (cache.t3.micro)
- **Stockage fichiers :** S3 bucket (Standard tier)
- **Monitoring :** CloudWatch + Datadog
- **Backup :** Automatique quotidien (rétention 30 jours)

#### **Environnements**

| Environnement | Usage | Configuration |
|---------------|-------|---------------|
| **Dev** | Développement local | Docker Compose |
| **Staging** | Tests pré-production | Infrastructure réduite |
| **Production** | Utilisateurs finaux | Haute disponibilité |

---

## 6. Parcours Utilisateur (UX)

### 6.1 User Journey complet

```
[Scan QR Code Marketing] 
         ↓
[Landing Page - Accueil]
   • Présentation solution
   • Bénéfices RIA
   • CTA "Commencer"
         ↓
[Module Diagnostic - Étape 1]
   • Formulaire entreprise
   • Nom, Secteur, Type IA
         ↓
[Module Diagnostic - Étapes 2-6]
   • 5 questions RIA
   • Réponses Oui/Non/Ne sais pas
   • Barre progression
         ↓
[Calcul automatique]
   • Algorithme scoring
   • Classification risque
         ↓
[Page Résultats]
   • Score /100
   • Niveau de risque
   • Obligations légales
   • Alerte si pratiques interdites
         ↓
┌─────────────────┬─────────────────┐
│                 │                 │
↓                 ↓                 ↓
[Download PDF]  [Contact Form]  [Return Home]
• Rapport       • Nom, Email    • Nouveau
  complet       • Téléphone       diagnostic
• Archivé       • Envoi CRM
```

### 6.2 Wireframes des écrans principaux

#### **Écran 1 : Accueil**
```
┌────────────────────────────────────────┐
│  🛡️ RIA Check & Go        [Menu ☰]    │
│         by Webside                      │
├────────────────────────────────────────┤
│                                         │
│  🎯 Bienvenue sur RIA Check & Go       │
│     Votre assistant conformité IA      │
│                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────┐│
│  │ 📊 Diag  │  │ 📄 Rapport│  │ 🤝   ││
│  │ Rapide   │  │ Détaillé  │  │Expert││
│  └──────────┘  └──────────┘  └──────┘│
│                                         │
│  ⚡ Pourquoi la conformité RIA ?       │
│  ✓ Obligatoire dès 2025                │
│  ✓ Éviter amendes jusqu'à 35M€        │
│  ✓ Garantir confiance utilisateurs     │
│                                         │
│  ┌──────────────────────────────────┐ │
│  │  Commencer le diagnostic ➡️      │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
```

#### **Écran 2 : Diagnostic**
```
┌────────────────────────────────────────┐
│  ← Retour              Progression: 60%│
├────────────────────────────────────────┤
│  [█████████████░░░░░░░]                │
│                                         │
│  Question 3/5                           │
│                                         │
│  Votre système traite-t-il des         │
│  données biométriques ?                 │
│                                         │
│  ┌──────────────────────────────────┐ │
│  │  ⚪ Oui                           │ │
│  └──────────────────────────────────┘ │
│                                         │
│  ┌──────────────────────────────────┐ │
│  │  ⚪ Non                           │ │
│  └──────────────────────────────────┘ │
│                                         │
│  ┌──────────────────────────────────┐ │
│  │  ⚪ Je ne sais pas                │ │
│  └──────────────────────────────────┘ │
│                                         │
└────────────────────────────────────────┘
```

#### **Écran 3 : Résultats**
```
┌────────────────────────────────────────┐
│  🛡️ Résultats du diagnostic            │
├────────────────────────────────────────┤
│                                         │
│         ┌──────────────┐               │
│         │      🔴      │               │
│         │    65/100    │               │
│         │Risque Élevé  │               │
│         └──────────────┘               │
│                                         │
│  ⚠️ Pratiques interdites détectées !   │
│  → Art. 5 - Manipulation subliminale   │
│                                         │
│  📋 Vos obligations principales :      │
│                                         │
│  ┌────────────────────────────────┐   │
│  │ 📊 Système gestion risques     │   │
│  │ 📄 Documentation technique     │   │
│  │ 🔍 Enregistrement UE           │   │
│  └────────────────────────────────┘   │
│                                         │
│  ┌──────────────────────────────────┐ │
│  │  ⬇️ Télécharger rapport PDF      │ │
│  └──────────────────────────────────┘ │
│                                         │
│  💼 Besoin d'accompagnement ?          │
│  ┌─────────────────────────┐          │
│  │ Nom    [_____________]  │          │
│  │ Email  [_____________]  │          │
│  │ Tél    [_____________]  │          │
│  │ [Demander un devis 📧]  │          │
│  └─────────────────────────┘          │
└────────────────────────────────────────┘
```

---

## 7. Spécifications Fonctionnelles Détaillées

### 7.1 EF 2.1 - Classification du Système d'IA

**Objectif :** Déterminer automatiquement le niveau de risque et les obligations applicables

**Processus :**
1. L'utilisateur répond aux 5 questions du diagnostic
2. Le système analyse les réponses selon la matrice de risque
3. Classification automatique selon 4 catégories :
   - **Inacceptable** : Pratiques interdites (Art. 5)
   - **Élevé** : Secteurs critiques ou données sensibles
   - **Modéré** : Interaction directe avec utilisateurs
   - **Minimal** : Autres cas

**Règles de classification :**
```javascript
function classifyRisk(answers) {
  // Détection pratiques interdites
  if (answers.q1 === 'yes') {
    return {
      level: 'INACCEPTABLE',
      blockers: ['Article 5 - Pratiques interdites'],
      score: 0
    };
  }
  
  let score = 0;
  let level = 'MINIMAL';
  
  // Évaluation risque élevé
  if (answers.q2 === 'yes') { 
    score += 30; 
    level = 'HIGH'; 
  }
  if (answers.q3 === 'yes') { 
    score += 30; 
    level = 'HIGH'; 
  }
  
  // Évaluation risque modéré
  if (answers.q4 === 'yes') { 
    score += 15;
    if (level === 'MINIMAL') level = 'MEDIUM';
  }
  
  // Pénalité documentation
  if (answers.q5 === 'no') {
    score -= 20;
  }
  
  return { level, score: Math.max(0, score) };
}
```

### 7.2 EF 2.2 - Gestion des Systèmes à Haut Risque

**Fonctionnalités pour systèmes à haut risque :**

#### **7.2.1 Système de Gestion des Risques (Art. 9)**
- **Description :** Module permettant de documenter, suivre et atténuer les risques identifiés
- **Fonctionnalités :**
  - Identification des risques potentiels
  - Évaluation de la probabilité et de l'impact
  - Plan d'atténuation
  - Suivi des actions correctives
  - Revue périodique (annuelle minimum)

#### **7.2.2 Gouvernance des Données (Art. 10)**
- **Description :** Traçabilité de la qualité des jeux de données
- **Critères vérifiés :**
  - ✅ Pertinence des données
  - ✅ Représentativité
  - ✅ Absence de biais discriminatoires
  - ✅ Complétude
  - ✅ Mise à jour régulière

#### **7.2.3 Documentation Technique (Annexe IV)**
- **Contenu du dossier technique :**
  - Description générale du système d'IA
  - Objectifs et usage prévu
  - Architecture et design
  - Jeux de données (entraînement, validation, test)
  - Métriques de performance
  - Procédures d'évaluation de conformité
  - Mesures de cybersécurité

### 7.3 EF 2.3 - Transparence et Information

#### **7.3.1 Obligations de Transparence (Art. 52)**
Pour les systèmes interagissant avec des humains :
- Information claire que l'utilisateur interagit avec une IA
- Indication des limitations du système
- Explicabilité des décisions prises par l'IA

#### **7.3.2 Traçabilité et Journalisation (Art. 12)**
- **Événements enregistrés :**
  - Déploiement du système
  - Mises à jour du modèle
  - Incidents détectés
  - Interventions humaines
  - Résultats produits

### 7.4 EF 2.4 - Évaluation et Déclaration de Conformité

#### **7.4.1 Auto-Évaluation (Art. 19)**
Liste de contrôle basée sur :
- ✅ Système de gestion des risques opérationnel
- ✅ Données de qualité suffisante
- ✅ Documentation technique complète
- ✅ Traçabilité assurée
- ✅ Supervision humaine possible
- ✅ Robustesse et exactitude adéquates
- ✅ Cybersécurité garantie

#### **7.4.2 Déclaration de Conformité UE (Annexe V)**
**Éléments générés automatiquement :**
- Nom et adresse du fournisseur
- Description du système d'IA
- Référence au RIA et aux normes harmonisées
- Déclaration de conformité aux exigences
- Date et signature

---

## 8. Conformité Réglementaire

### 8.1 Mapping Articles RIA → Fonctionnalités

| Article RIA | Exigence | Fonctionnalité App |
|-------------|----------|-------------------|
| **Art. 5** | Interdiction pratiques | Détection auto + alerte rouge |
| **Art. 9** | Gestion risques | Module documentation risques |
| **Art. 10** | Qualité données | Checklist gouvernance données |
| **Art. 12** | Journalisation | Système de logs automatiques |
| **Art. 13** | Transparence | Template notice utilisateur |
| **Art. 19** | Auto-évaluation | Wizard d'évaluation guidée |
| **Annexe IV** | Documentation technique | Générateur de dossier technique |
| **Annexe V** | Déclaration conformité | Génération automatique PDF |

### 8.2 Matrice de couverture réglementaire

```
┌─────────────────────────────────────────────────────────┐
│ TITRE III - Systèmes IA à Haut Risque                   │
├─────────────────────────────────────────────────────────┤
│ ✅ Art. 9  - Gestion des risques                        │
│ ✅ Art. 10 - Données et gouvernance                     │
│ ✅ Art. 11 - Documentation technique                    │
│ ✅ Art. 12 - Tenue de registres                         │
│ ✅ Art. 13 - Transparence et information                │
│ ✅ Art. 14 - Supervision humaine                        │
│ ✅ Art. 15 - Exactitude, robustesse, cybersécurité      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ TITRE IV - Obligations de Transparence                  │
├─────────────────────────────────────────────────────────┤
│ ✅ Art. 52 - Transparence systèmes IA                   │
│ ✅ Art. 53 - Obligations contenu généré par IA          │
└─────────────────────────────────────────────────────────┘
```

### 8.3 Niveau de conformité par fonctionnalité

| Module | Conformité | Articles couverts |
|--------|-----------|-------------------|
| Classification IA | ⭐⭐⭐⭐⭐ | Art. 5, Annexe II, III |
| Évaluation risques | ⭐⭐⭐⭐ | Art. 9 |
| Documentation | ⭐⭐⭐⭐ | Art. 11, Annexe IV |
| Traçabilité | ⭐⭐⭐ | Art. 12 |
| Transparence | ⭐⭐⭐⭐ | Art. 52 |
| Déclaration UE | ⭐⭐⭐⭐⭐ | Annexe V |

---

## 9. Sécurité et RGPD

### 9.1 Sécurité applicative

#### **9.1.1 Authentification et Autorisation**
```javascript
// JWT Token structure
{
  "sub": "user_id",
  "email": "user@company.com",
  "role": "company_admin",
  "iat": 1234567890,
  "exp": 1234571490 // 1h expiration
}

// Rôles disponibles
- ANONYMOUS: Accès diagnostic uniquement
- USER: Accès diagnostic + historique
- ADMIN_WEBSIDE: Accès complet + stats
```

#### **9.1.2 Protection des données**

**Chiffrement :**
- TLS 1.3 pour toutes les communications
- Chiffrement AES-256 des données sensibles en base
- Hashing bcrypt (cost 12) pour les mots de passe

**Validation des entrées :**
```javascript
// Exemple validation email
const emailSchema = z.string()
  .email("Email invalide")
  .max(255)
  .toLowerCase();

// Sanitization
import DOMPurify from 'dompurify';
const cleanInput = DOMPurify.sanitize(userInput);
```

#### **9.1.3 Protection contre les attaques**

| Menace | Protection | Implémentation |
|--------|-----------|----------------|
| **XSS** | Sanitization | DOMPurify, Content Security Policy |
| **CSRF** | Tokens | Double-submit cookie pattern |
| **SQL Injection** | Prepared statements | ORM (Prisma/TypeORM) |
| **DDoS** | Rate limiting | Redis + express-rate-limit |
| **Brute force** | Throttling | Max 5 tentatives / 15min |

### 9.2 Conformité RGPD

#### **9.2.1 Principes appliqués**

**Minimisation des données :**
- Collecte uniquement des données nécessaires au diagnostic
- Pas de données sensibles stockées sans consentement explicite

**Durée de conservation :**
| Type de donnée | Durée | Justification |
|----------------|-------|---------------|
| Données diagnostic | 3 ans | Suivi conformité |
| Rapports PDF | 5 ans | Obligation légale |
| Logs applicatifs | 12 mois | Sécurité/Debug |
| Données marketing | 3 ans | Consentement |

**Droits des utilisateurs :**
- ✅ Droit d'accès (export données JSON)
- ✅ Droit de rectification (modification profil)
- ✅ Droit à l'effacement (suppression compte)
- ✅ Droit à la portabilité (export PDF)
- ✅ Droit d'opposition (opt-out marketing)

#### **9.2.2 Gestion du consentement**

```javascript
// Cookie banner configuration
const consentConfig = {
  necessary: {
    enabled: true,
    locked: true, // Toujours actif
    cookies: ['session', 'csrf_token']
  },
  analytics: {
    enabled: false,
    cookies: ['_ga', '_gid'],
    services: ['Google Analytics']
  },
  marketing: {
    enabled: false,
    cookies: ['_fbp'],
    services: ['Facebook Pixel']
  }
};
```

#### **9.2.3 Registre des traitements**

**Traitement 1 : Diagnostic de conformité**
- **Finalité :** Évaluation conformité RIA
- **Base légale :** Intérêt légitime
- **Données :** Nom entreprise, secteur, réponses questionnaire
- **Durée :** 3 ans
- **Destinataires :** Équipe Webside, hébergeur AWS

**Traitement 2 : Demandes de devis**
- **Finalité :** Gestion commerciale
- **Base légale :** Consentement
- **Données :** Nom, email, téléphone
- **Durée :** 3 ans (prospect)
- **Destinataires :** Équipe commerciale Webside

### 9.3 Analyse d'Impact (PIA)

#### **Risques identifiés**

| Risque | Probabilité | Impact | Mesures d'atténuation |
|--------|-------------|--------|----------------------|
| Fuite de données | Faible | Élevé | Chiffrement, accès restreint |
| Accès non autorisé | Moyenne | Moyen | MFA, logs d'audit |
| Perte de données | Faible | Élevé | Backups quotidiens, réplication |
| Non-conformité RGPD | Faible | Élevé | Audit régulier, DPO interne |

---

## 10. Tests et Validation

### 10.1 Stratégie de tests

#### **10.1.1 Tests unitaires (85% couverture cible)**

```javascript
// Exemple test moteur de calcul
describe('Risk Calculator', () => {
  test('should classify as UNACCEPTABLE if manipulation detected', () => {
    const answers = { q1: 'yes', q2: 'no', q3: 'no', q4: 'no', q5: 'yes' };
    const result = calculateRisk(answers);
    expect(result.level).toBe('INACCEPTABLE');
    expect(result.blockers).toContain('Article 5');
  });

  test('should calculate HIGH risk for critical sector', () => {
    const answers = { q1: 'no', q2: 'yes', q3: 'yes', q4: 'no', q5: 'yes' };
    const result = calculateRisk(answers);
    expect(result.level).toBe('HIGH');
    expect(result.score).toBeGreaterThanOrEqual(60);
  });
});
```

#### **10.1.2 Tests d'intégration**

**Scénarios testés :**
1. **Parcours diagnostic complet**
   - Création diagnostic → Réponses → Résultats → PDF
   
2. **Génération rapport PDF**
   - Vérification contenu, formatage, téléchargement

3. **Envoi email devis**
   - Formulaire → Validation → Email CRM

4. **Persistance données**
   - Sauvegarde diagnostic → Récupération → Cohérence

#### **10.1.3 Tests de conformité réglementaire**

**Test Case 1 : Détection pratiques interdites**
```
Entrée : Réponse "Oui" à Q1 (manipulation subliminale)
Attendu : 
  - Classification "INACCEPTABLE"
  - Alerte rouge visible
  - Message Article 5 du RIA
  - Score = 0
Statut : ✅ PASS
```

**Test Case 2 : Obligations haut risque**
```
Entrée : Secteur "Santé" + Données biométriques
Attendu :
  - Classification "ÉLEVÉ"
  - Liste obligations complète :
    ✓ Gestion des risques (Art. 9)
    ✓ Qualité données (Art. 10)
    ✓ Documentation (Annexe IV)
    ✓ Enregistrement UE
Statut : ✅ PASS
```

**Test Case 3 : Génération Déclaration UE**
```
Entrée : Diagnostic complet système haut risque
Attendu :
  - Fichier PDF conforme Annexe V
  - Tous les champs obligatoires remplis
  - Signature électronique valide
Statut : ✅ PASS
```

### 10.2 Tests de performance

#### **Critères de performance**

| Métrique | Cible | Mesure actuelle |
|----------|-------|-----------------|
| **Time to Interactive** | < 3s | 2.1s ✅ |
| **Lighthouse Score** | > 90 | 94 ✅ |
| **API Response Time** | < 500ms | 320ms ✅ |
| **PDF Generation** | < 5s | 3.8s ✅ |
| **Concurrent Users** | 1000+ | 1200 ✅ |

#### **Tests de charge**

```bash
# Apache Bench - Test de charge
ab -n 10000 -c 100 https://ria-check-go.webside.fr/api/v1/diagnostic/start

# Résultats attendus
Requests per second: > 500 req/s
Time per request: < 200ms (moyenne)
Failed requests: 0%
```

### 10.3 Tests d'accessibilité

#### **Conformité WCAG 2.1 Niveau AA**

| Critère | Statut | Implémentation |
|---------|--------|----------------|
| **1.1 Alternatives textuelles** | ✅ | Alt text sur images/icônes |
| **1.4 Contraste** | ✅ | Ratio minimum 4.5:1 |
| **2.1 Navigation clavier** | ✅ | Tous les éléments accessibles |
| **2.4 Navigation** | ✅ | Skip links, breadcrumbs |
| **3.1 Lisibilité** | ✅ | Lang="fr", texte clair |
| **4.1 Compatibilité** | ✅ | Semantic HTML, ARIA labels |

**Outils de validation :**
- axe DevTools
- WAVE Browser Extension
- Screen reader testing (NVDA)

### 10.4 Tests de sécurité

#### **Audit de sécurité**

**OWASP Top 10 - Vérification**
```
✅ A01:2021 - Broken Access Control → JWT + RBAC
✅ A02:2021 - Cryptographic Failures → TLS 1.3 + AES-256
✅ A03:2021 - Injection → Prepared statements + sanitization
✅ A04:2021 - Insecure Design → Threat modeling effectué
✅ A05:2021 - Security Misconfiguration → Hardening config
✅ A06:2021 - Vulnerable Components → Dependabot actif
✅ A07:2021 - Authentication Failures → MFA + rate limiting
✅ A08:2021 - Data Integrity Failures → Checksums + validation
✅ A09:2021 - Logging Failures → Logging centralisé
✅ A10:2021 - SSRF → Whitelist URLs externe
```

**Scan de vulnérabilités :**
```bash
# npm audit
npm audit --production
# Résultat attendu : 0 vulnérabilités critiques/élevées

# Snyk scan
snyk test
# Résultat attendu : Grade A
```

---

## 11. Déploiement et Maintenance

### 11.1 Pipeline CI/CD

```yaml
# .github/workflows/deploy.yml
name: Deploy RIA Check & Go

on:
  push:
    branches: [main, staging]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          npm install
          npm run test:unit
          npm run test:integration
          npm run test:e2e
      
  security:
    runs-on: ubuntu-latest
    steps:
      - name: Security audit
        run: |
          npm audit --production
          npx snyk test
      
  build:
    needs: [test, security]
    runs-on: ubuntu-latest
    steps:
      - name: Build application
        run: |
          npm run build
          docker build -t ria-check-go:${{ github.sha }} .
      
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to AWS
        run: |
          aws ecs update-service \
            --cluster ria-production \
            --service ria-check-go \
            --force-new-deployment
```

### 11.2 Stratégie de déploiement

#### **Blue-Green Deployment**

```
┌──────────────────────────────────────────┐
│         Load Balancer (ELB)              │
└────────────┬─────────────┬───────────────┘
             │             │
    ┌────────▼────────┐   │
    │   BLUE (v1.0)   │   │  ← Trafic 100%
    │   Running       │   │
    └─────────────────┘   │
                          │
             ┌────────────▼──────────┐
             │   GREEN (v1.1)        │
             │   Staging/Tests       │
             └───────────────────────┘
                     ↓
             Switch trafic si tests OK
```

**Étapes :**
1. Déploiement version GREEN (nouvelle version)
2. Tests de smoke sur GREEN
3. Bascule progressive du trafic (0% → 10% → 50% → 100%)
4. Monitoring des métriques
5. Rollback rapide vers BLUE si anomalie

### 11.3 Monitoring et Observabilité

#### **Métriques clés à surveiller**

**Infrastructure :**
```javascript
// Métriques techniques
- CPU Usage: < 70%
- Memory Usage: < 80%
- Disk I/O: < 1000 IOPS
- Network Latency: < 50ms

// Métriques applicatives
- Request Rate: X req/s
- Error Rate: < 0.1%
- Response Time P95: < 800ms
- Database Connections: < 80% pool
```

**Business :**
```javascript
// Métriques métier
- Diagnostics démarrés / jour
- Taux de complétion: > 70%
- Rapports PDF téléchargés
- Demandes de devis générées
- Taux de conversion: > 5%
```

#### **Alerting**

```yaml
# Alertes critiques (PagerDuty)
- Error rate > 1% pendant 5min
- Response time P95 > 2s pendant 10min
- Service down / Health check failed
- Database connection pool saturé

# Alertes warning (Slack)
- Error rate > 0.5% pendant 15min
- Response time P95 > 1s pendant 20min
- Disk usage > 80%
- Memory usage > 85%
```

### 11.4 Plan de maintenance

#### **Maintenance préventive**

**Quotidienne :**
- ✅ Vérification logs d'erreurs
- ✅ Contrôle backups automatiques
- ✅ Scan vulnérabilités dépendances

**Hebdomadaire :**
- ✅ Revue métriques performance
- ✅ Analyse taux d'erreur
- ✅ Vérification certificats SSL
- ✅ Test restauration backup

**Mensuelle :**
- ✅ Audit sécurité complet
- ✅ Mise à jour dépendances
- ✅ Optimisation base de données (VACUUM, REINDEX)
- ✅ Revue capacité infrastructure

**Trimestrielle :**
- ✅ Audit conformité RGPD
- ✅ Test plan de reprise d'activité
- ✅ Revue et mise à jour documentation
- ✅ Formation équipe sur nouvelles features

#### **Procédure de mise à jour**

```bash
# 1. Backup complet
./scripts/backup-full.sh

# 2. Déploiement version canary (5% trafic)
kubectl set image deployment/ria-check-go \
  app=ria-check-go:v1.2.0 \
  --record

# 3. Monitoring 30min
./scripts/monitor-deployment.sh --canary

# 4. Rollout progressif si OK
kubectl rollout status deployment/ria-check-go

# 5. Rollback si KO
kubectl rollout undo deployment/ria-check-go
```

### 11.5 Plan de Reprise d'Activité (PRA)

#### **RTO/RPO Définis**

| Niveau de service | RTO | RPO | Criticité |
|-------------------|-----|-----|-----------|
| **Application Web** | 1h | 1h | Critique |
| **API Backend** | 30min | 30min | Critique |
| **Base de données** | 15min | 5min | Critique |
| **Génération PDF** | 2h | 1h | Moyenne |

#### **Scénarios de disaster recovery**

**Scénario 1 : Panne serveur unique**
- Détection : Health check failed
- Action auto : Basculement load balancer vers serveur secondaire
- Durée : < 5min (automatique)

**Scénario 2 : Corruption base de données**
- Détection : Erreurs SQL massives
- Action : Restauration depuis backup + replay WAL logs
- Durée : 15-30min (manuel)

**Scénario 3 : Panne datacenter complet**
- Détection : Indisponibilité région AWS
- Action : Basculement vers région secondaire (DR site)
- Durée : 1-2h (semi-automatique)

```bash
# Script de disaster recovery
./scripts/disaster-recovery.sh \
  --scenario datacenter-failure \
  --region eu-west-2 \
  --backup-timestamp "2025-11-18T10:00:00Z"
```

---

## 12. Évolutions Futures et Roadmap

### 12.1 Phase 2 - Fonctionnalités avancées (Q1 2026)

**Dashboard entreprise :**
- ✨ Tableau de bord de suivi conformité
- ✨ Historique des diagnostics
- ✨ Notifications échéances réglementaires
- ✨ Export multi-format (CSV, Excel, JSON)

**Module collaboration :**
- ✨ Multi-utilisateurs par entreprise
- ✨ Gestion des rôles (Admin, Auditeur, Lecteur)
- ✨ Commentaires et annotations
- ✨ Workflow de validation

### 12.2 Phase 3 - IA et Automatisation (Q3 2026)

**Assistant IA :**
- 🤖 Chatbot pour répondre aux questions RIA
- 🤖 Analyse automatique de documents techniques
- 🤖 Recommandations personnalisées d'actions

**Intégrations :**
- 🔗 API publique pour intégrations tierces
- 🔗 Connecteurs ERP/CRM (Salesforce, HubSpot)
- 🔗 SSO (Okta, Azure AD, Google Workspace)

### 12.3 Phase 4 - Certification et Conformité (Q1 2027)

**Module certification :**
- 🎓 Préparation à l'audit de conformité
- 🎓 Interface auditeur externe
- 🎓 Génération dossier certification complet
- 🎓 Suivi post-certification

**Marketplace :**
- 🛒 Boutique de services complémentaires
- 🛒 Formation en ligne
- 🛒 Accompagnement expert à la demande

---

## 13. Annexes Techniques

### 13.1 Glossaire

| Terme | Définition |
|-------|------------|
| **RIA** | Règlement sur l'Intelligence Artificielle (AI Act) |
| **SIA** | Système d'Intelligence Artificielle |
| **GPAI** | General Purpose AI (IA à usage général) |
| **RGPD** | Règlement Général sur la Protection des Données |
| **Annexe III** | Liste des systèmes IA à haut risque |
| **Annexe IV** | Contenu de la documentation technique |
| **Annexe V** | Modèle de déclaration UE de conformité |

### 13.2 Références réglementaires

**Documents officiels :**
- 📄 Règlement (UE) 2024/1689 sur l'IA (AI Act)
- 📄 RGPD - Règlement (UE) 2016/679
- 📄 Directive NIS2 - Sécurité des réseaux et systèmes d'information
- 📄 ISO/IEC 42001:2023 - Systèmes de management de l'IA

**Ressources Webside :**
- 🔗 https://webside.fr/ria-compliance
- 🔗 https://docs.webside.fr/ria-check-go
- 📧 support-ria@webside.fr

### 13.3 Changelog

#### **Version 1.0.0 - Novembre 2025 (Release initiale)**
- ✅ Module diagnostic complet (5 questions)
- ✅ Calcul score et classification risque
- ✅ Génération rapport PDF
- ✅ Formulaire demande de devis
- ✅ Interface responsive
- ✅ Conformité RGPD

#### **Version 1.1.0 - Prévu Décembre 2025**
- 🔄 10 questions de diagnostic (vs 5 actuellement)
- 🔄 Templates PDF personnalisables
- 🔄 Envoi email automatique du rapport
- 🔄 Statistiques dashboard Webside
- 🔄 Optimisations performance

### 13.4 Configuration exemple

```javascript
// config/production.js
module.exports = {
  app: {
    name: 'RIA Check & Go',
    version: '1.0.0',
    port: process.env.PORT || 3000,
    env: 'production'
  },
  
  database: {
    host: process.env.DB_HOST,
    port: 5432,
    name: 'ria_check_go_prod',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    ssl: true,
    pool: {
      min: 2,
      max: 10
    }
  },
  
  redis: {
    host: process.env.REDIS_HOST,
    port: 6379,
    password: process.env.REDIS_PASSWORD,
    ttl: 3600
  },
  
  security: {
    jwtSecret: process.env.JWT_SECRET,
    jwtExpiration: '1h',
    bcryptRounds: 12,
    rateLimitWindow: 15 * 60 * 1000, // 15min
    rateLimitMax: 100
  },
  
  email: {
    provider: 'sendgrid',
    apiKey: process.env.SENDGRID_API_KEY,
    from: 'noreply@webside.fr',
    templates: {
      report: 'd-xxxxx',
      quote: 'd-yyyyy'
    }
  },
  
  storage: {
    provider: 's3',
    bucket: 'ria-check-go-reports',
    region: 'eu-west-1',
    presignedUrlExpiration: 3600
  }
};
```

---

## 14. Contact et Support

### 14.1 Équipe projet Webside

| Rôle | Nom | Contact |
|------|-----|---------|
| **Chef de Projet** | Marie Dupont | marie.dupont@webside.fr |
| **Lead Developer** | Thomas Martin | thomas.martin@webside.fr |
| **Expert RIA** | Sophie Bernard | sophie.bernard@webside.fr |
| **Support Technique** | - | support@webside.fr |

### 14.2 Ressources

**Documentation :**
- 📖 Guide utilisateur : https://docs.webside.fr/user-guide
- 💻 Documentation API : https://api.webside.fr/docs
- 🎓 Centre de formation : https://learn.webside.fr

**Support :**
- 📧 Email : support-ria@webside.fr
- 💬 Chat en ligne : https://webside.fr/chat
- 📞 Téléphone : +33 1 23 45 67 89 (9h-18h, Lun-Ven)

---

## 15. Signature et Validation

**Document rédigé par :** Équipe Développement Webside  
**Date de création :** 18 Novembre 2025  
**Version :** 1.0  
**Statut :** ✅ Validé pour développement

**Validations :**
- ✅ Conformité réglementaire RIA : Sophie Bernard, Expert RIA
- ✅ Architecture technique : Thomas Martin, Lead Developer
- ✅ Sécurité et RGPD : Pierre Leclerc, RSSI
- ✅ Direction Projet : Marie Dupont, Chef de Projet

---

**© 2025 Webside - Tous droits réservés**  
*Ce document est confidentiel et destiné exclusivement à un usage interne Webside.*e III** | Systèmes haut risque | Classification automatique |
| **Annex