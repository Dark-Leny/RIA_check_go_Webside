-- ============================================================================
-- BASE DE DONNÉES RIA CHECK & GO - WEBSIDE
-- ============================================================================
-- Version: 1.0
-- SGBD: SQLite 3
-- Encodage: UTF-8
-- Date: Novembre 2025
-- ============================================================================

-- ============================================================================
-- 1. ACTIVATION DES CLÉS ÉTRANGÈRES
-- ============================================================================

PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";

-- ============================================================================
-- 2. SUPPRESSION DES TABLES EXISTANTES (si elles existent)
-- ============================================================================

DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS contact_requests;
DROP TABLE IF EXISTS diagnostic_obligations;
DROP TABLE IF EXISTS obligations;
DROP TABLE IF EXISTS diagnostic_answers;
DROP TABLE IF EXISTS diagnostics;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS users;

-- ============================================================================
-- 3. CRÉATION DES TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: users (pour futures évolutions avec authentification)
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT, -- Bcrypt hash
    first_name TEXT,
    last_name TEXT,
    role TEXT DEFAULT 'USER' CHECK (role IN ('USER', 'ADMIN', 'WEBSIDE_ADMIN')),
    is_active INTEGER DEFAULT 1, -- 0=false, 1=true
    email_verified INTEGER DEFAULT 0,
    last_login TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Index sur email pour recherches rapides
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ----------------------------------------------------------------------------
-- Table: companies
-- ----------------------------------------------------------------------------
CREATE TABLE companies (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    name TEXT NOT NULL,
    sector TEXT NOT NULL CHECK (sector IN (
        'sante', 'finance', 'transport', 'education', 
        'energie', 'telecommunication', 'industrie', 
        'services', 'commerce', 'autre'
    )),
    ai_system_type TEXT,
    siret TEXT, -- Numéro SIRET français (14 chiffres)
    address TEXT,
    city TEXT,
    postal_code TEXT,
    country TEXT DEFAULT 'FR', -- ISO 3166-1 alpha-2
    website TEXT,
    created_by TEXT REFERENCES users(id) ON DELETE SET NULL,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Index pour recherches
CREATE INDEX idx_companies_name ON companies(name);
CREATE INDEX idx_companies_sector ON companies(sector);
CREATE INDEX idx_companies_created_at ON companies(created_at DESC);

-- ----------------------------------------------------------------------------
-- Table: diagnostics
-- ----------------------------------------------------------------------------
CREATE TABLE diagnostics (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    company_id TEXT REFERENCES companies(id) ON DELETE CASCADE,
    session_token TEXT UNIQUE NOT NULL,
    status TEXT DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'abandoned')),
    score INTEGER CHECK (score >= 0 AND score <= 100),
    risk_level TEXT CHECK (risk_level IN ('minimal', 'medium', 'high', 'inacceptable')),
    has_unacceptable_practices INTEGER DEFAULT 0, -- 0=false, 1=true
    ip_address TEXT, -- Adresse IP pour analytics
    user_agent TEXT, -- User agent pour analytics
    started_at TEXT DEFAULT (datetime('now')),
    completed_at TEXT
);

-- Index pour performances
CREATE INDEX idx_diagnostics_session ON diagnostics(session_token);
CREATE INDEX idx_diagnostics_company ON diagnostics(company_id);
CREATE INDEX idx_diagnostics_status ON diagnostics(status);
CREATE INDEX idx_diagnostics_completed_at ON diagnostics(completed_at DESC);
CREATE INDEX idx_diagnostics_risk_level ON diagnostics(risk_level);

-- ----------------------------------------------------------------------------
-- Table: diagnostic_answers
-- ----------------------------------------------------------------------------
CREATE TABLE diagnostic_answers (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    diagnostic_id TEXT NOT NULL REFERENCES diagnostics(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL,
    answer TEXT NOT NULL CHECK (answer IN ('yes', 'no', 'unknown')),
    answered_at TEXT DEFAULT (datetime('now')),
    UNIQUE(diagnostic_id, question_id)
);

-- Index pour jointures rapides
CREATE INDEX idx_answers_diagnostic ON diagnostic_answers(diagnostic_id);
CREATE INDEX idx_answers_question ON diagnostic_answers(question_id);

-- ----------------------------------------------------------------------------
-- Table: obligations (référentiel des obligations RIA)
-- ----------------------------------------------------------------------------
CREATE TABLE obligations (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    risk_level TEXT CHECK (risk_level IN ('minimal', 'medium', 'high', 'inacceptable')),
    article_reference TEXT,
    category TEXT CHECK (category IN (
        'interdiction', 'gestion_risques', 'donnees', 
        'documentation', 'transparence', 'enregistrement', 
        'supervision', 'securite'
    )),
    priority INTEGER DEFAULT 0, -- 0=basse, 1=moyenne, 2=haute, 3=critique
    is_active INTEGER DEFAULT 1, -- 0=false, 1=true
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Index pour recherches
CREATE INDEX idx_obligations_code ON obligations(code);
CREATE INDEX idx_obligations_risk_level ON obligations(risk_level);
CREATE INDEX idx_obligations_category ON obligations(category);

-- ----------------------------------------------------------------------------
-- Table: diagnostic_obligations (relation N:N)
-- ----------------------------------------------------------------------------
CREATE TABLE diagnostic_obligations (
    diagnostic_id TEXT NOT NULL REFERENCES diagnostics(id) ON DELETE CASCADE,
    obligation_id TEXT NOT NULL REFERENCES obligations(id) ON DELETE CASCADE,
    assigned_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (diagnostic_id, obligation_id)
);

-- Index pour jointures
CREATE INDEX idx_diag_obl_diagnostic ON diagnostic_obligations(diagnostic_id);
CREATE INDEX idx_diag_obl_obligation ON diagnostic_obligations(obligation_id);

-- ----------------------------------------------------------------------------
-- Table: contact_requests
-- ----------------------------------------------------------------------------
CREATE TABLE contact_requests (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    diagnostic_id TEXT REFERENCES diagnostics(id) ON DELETE SET NULL,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    company_name TEXT,
    message TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN (
        'pending', 'contacted', 'qualified', 
        'quote_sent', 'won', 'lost', 'spam'
    )),
    assigned_to TEXT REFERENCES users(id) ON DELETE SET NULL, -- Commercial Webside assigné
    source TEXT DEFAULT 'diagnostic' CHECK (source IN ('diagnostic', 'website', 'phone', 'other')),
    notes TEXT, -- Notes internes Webside
    contacted_at TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Index pour CRM
CREATE INDEX idx_contact_status ON contact_requests(status);
CREATE INDEX idx_contact_created_at ON contact_requests(created_at DESC);
CREATE INDEX idx_contact_diagnostic ON contact_requests(diagnostic_id);
CREATE INDEX idx_contact_assigned_to ON contact_requests(assigned_to);

-- ----------------------------------------------------------------------------
-- Table: reports (rapports PDF générés)
-- ----------------------------------------------------------------------------
CREATE TABLE reports (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    diagnostic_id TEXT NOT NULL REFERENCES diagnostics(id) ON DELETE CASCADE,
    pdf_url TEXT,
    pdf_filename TEXT,
    file_size_bytes INTEGER,
    storage_provider TEXT DEFAULT 's3' CHECK (storage_provider IN ('s3', 'local', 'gcs', 'azure')),
    is_downloaded INTEGER DEFAULT 0, -- 0=false, 1=true
    download_count INTEGER DEFAULT 0,
    generated_at TEXT DEFAULT (datetime('now')),
    downloaded_at TEXT,
    expires_at TEXT -- Date d'expiration du lien pré-signé
);

-- Index
CREATE INDEX idx_reports_diagnostic ON reports(diagnostic_id);
CREATE INDEX idx_reports_generated_at ON reports(generated_at DESC);

-- ============================================================================
-- 4. DONNÉES DE RÉFÉRENCE (SEED DATA)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Obligations RIA (référentiel)
-- ----------------------------------------------------------------------------

-- ==================== PRATIQUES INTERDITES (Article 5) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-001',
    'Interdiction des techniques de manipulation subliminale',
    'Interdiction de mettre sur le marché, de mettre en service ou d''utiliser un système d''IA qui déploie des techniques subliminales ayant pour objectif ou pour effet de fausser substantiellement le comportement d''une personne ou d''un groupe de personnes en portant considérablement atteinte à la capacité d''une personne de prendre une décision éclairée.',
    'inacceptable',
    'Article 5.1.a',
    'interdiction',
    3
),
(
    'OBL-002',
    'Interdiction d''exploitation des vulnérabilités',
    'Interdiction de systèmes d''IA qui exploitent les vulnérabilités d''un groupe spécifique de personnes en raison de leur âge ou de leur handicap physique ou mental.',
    'inacceptable',
    'Article 5.1.b',
    'interdiction',
    3
),
(
    'OBL-003',
    'Interdiction du scoring social',
    'Interdiction de systèmes d''IA utilisés par des autorités publiques pour évaluer ou classer la fiabilité des personnes physiques sur la base de leur comportement social (scoring social).',
    'inacceptable',
    'Article 5.1.c',
    'interdiction',
    3
);

-- ==================== GESTION DES RISQUES (Article 9) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-100',
    'Système de gestion des risques',
    'Mettre en place, documenter et maintenir un système de gestion des risques constitué d''un processus continu et itératif planifié et exécuté tout au long du cycle de vie d''un système d''IA à haut risque.',
    'high',
    'Article 9.1',
    'gestion_risques',
    2
),
(
    'OBL-101',
    'Identification des risques',
    'Identification et analyse des risques connus et raisonnablement prévisibles que le système d''IA à haut risque peut présenter pour la santé, la sécurité et les droits fondamentaux.',
    'high',
    'Article 9.2.a',
    'gestion_risques',
    2
),
(
    'OBL-102',
    'Estimation et évaluation des risques',
    'Estimation et évaluation des risques pouvant apparaître lorsque le système d''IA à haut risque est utilisé conformément à sa destination et dans des conditions de mauvaise utilisation raisonnablement prévisible.',
    'high',
    'Article 9.2.b',
    'gestion_risques',
    2
),
(
    'OBL-103',
    'Évaluation des mesures de gestion des risques',
    'Évaluation des mesures de gestion des risques adoptées en tenant compte de l''état de la technique généralement reconnu.',
    'high',
    'Article 9.2.c',
    'gestion_risques',
    2
);

-- ==================== GOUVERNANCE DES DONNÉES (Article 10) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-200',
    'Gouvernance et pratiques en matière de données',
    'Les systèmes d''IA à haut risque doivent être développés sur la base de jeux de données d''entraînement, de validation et de test qui répondent à des critères de qualité appropriés.',
    'high',
    'Article 10.1',
    'donnees',
    2
),
(
    'OBL-201',
    'Pertinence et représentativité des données',
    'Les jeux de données d''entraînement, de validation et de test doivent être pertinents, suffisamment représentatifs, et dans la mesure du possible, exempts d''erreurs et complets au regard de la destination.',
    'high',
    'Article 10.3',
    'donnees',
    2
),
(
    'OBL-202',
    'Prévention des biais discriminatoires',
    'Les jeux de données doivent tenir compte des caractéristiques spécifiques au contexte géographique, comportemental ou fonctionnel dans lequel le système d''IA à haut risque est destiné à être utilisé, afin de détecter et prévenir les biais.',
    'high',
    'Article 10.3',
    'donnees',
    2
),
(
    'OBL-203',
    'Examen des biais dans les données',
    'Examen en vue de détecter d''éventuels biais susceptibles d''être à l''origine d''une discrimination interdite, en particulier en ce qui concerne les données sensibles.',
    'high',
    'Article 10.4',
    'donnees',
    2
);

-- ==================== DOCUMENTATION TECHNIQUE (Article 11 & Annexe IV) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-300',
    'Documentation technique',
    'Établir et tenir à jour la documentation technique d''un système d''IA à haut risque. Cette documentation doit être établie avant que le système ne soit mis sur le marché ou mis en service.',
    'high',
    'Article 11',
    'documentation',
    2
),
(
    'OBL-301',
    'Description générale du système',
    'Description générale du système d''IA incluant sa destination, le fournisseur, la version, et la façon dont le système interagit avec du matériel ou des logiciels.',
    'high',
    'Annexe IV.1',
    'documentation',
    2
),
(
    'OBL-302',
    'Documentation des éléments de conception',
    'Description détaillée des éléments du système et du processus de conception et de développement, y compris les méthodes et étapes de développement.',
    'high',
    'Annexe IV.2',
    'documentation',
    2
),
(
    'OBL-303',
    'Spécifications des données',
    'Informations détaillées sur les données : sources, procédures de sélection, d''étiquetage, de nettoyage et d''agrégation, ainsi que les méthodologies de détection des biais.',
    'high',
    'Annexe IV.2.d',
    'documentation',
    2
);

-- ==================== TRAÇABILITÉ ET JOURNALISATION (Article 12) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-400',
    'Tenue de registres (logs)',
    'Les systèmes d''IA à haut risque doivent être conçus de manière à permettre la journalisation automatique des événements tout au long de leur durée de vie.',
    'high',
    'Article 12.1',
    'documentation',
    2
),
(
    'OBL-401',
    'Capacités de journalisation',
    'Les capacités de journalisation doivent assurer un niveau de traçabilité du fonctionnement du système d''IA approprié à la destination de ce système.',
    'high',
    'Article 12.1',
    'documentation',
    2
),
(
    'OBL-402',
    'Conservation des journaux',
    'Conservation des journaux d''événements générés automatiquement par les systèmes d''IA à haut risque pendant une période appropriée à la destination du système.',
    'high',
    'Article 12.2',
    'documentation',
    2
);

-- ==================== TRANSPARENCE (Article 13 & Article 52) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-500',
    'Transparence et fourniture d''informations aux déployeurs',
    'Les systèmes d''IA à haut risque doivent être conçus et développés de manière à permettre aux déployeurs d''interpréter les résultats et de les utiliser de manière appropriée.',
    'high',
    'Article 13.1',
    'transparence',
    2
),
(
    'OBL-501',
    'Notice d''utilisation',
    'Les systèmes d''IA à haut risque doivent être accompagnés d''une notice d''utilisation dans un format numérique approprié ou sous une autre forme.',
    'high',
    'Article 13.3',
    'transparence',
    2
),
(
    'OBL-502',
    'Obligation de transparence pour systèmes interagissant avec personnes',
    'Les fournisseurs veillent à ce que les systèmes d''IA destinés à interagir avec des personnes physiques soient conçus de manière à informer les personnes qu''elles interagissent avec un système d''IA.',
    'medium',
    'Article 52.1',
    'transparence',
    1
),
(
    'OBL-503',
    'Information sur les contenus générés par IA',
    'Les déployeurs de systèmes d''IA qui génèrent des contenus artificiels (textes, images, audio, vidéo) révèlent que le contenu a été généré ou manipulé artificiellement.',
    'medium',
    'Article 52.3',
    'transparence',
    1
);

-- ==================== SUPERVISION HUMAINE (Article 14) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-600',
    'Supervision humaine',
    'Les systèmes d''IA à haut risque doivent être conçus de manière à pouvoir être effectivement supervisés par des personnes physiques pendant la période d''utilisation.',
    'high',
    'Article 14.1',
    'supervision',
    2
),
(
    'OBL-601',
    'Mesures de supervision appropriées',
    'Mise en œuvre de mesures techniques et organisationnelles appropriées pour permettre une supervision humaine efficace.',
    'high',
    'Article 14.4',
    'supervision',
    2
);

-- ==================== EXACTITUDE, ROBUSTESSE ET CYBERSÉCURITÉ (Article 15) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-700',
    'Exactitude',
    'Les systèmes d''IA à haut risque doivent être conçus de manière à atteindre un niveau approprié d''exactitude par rapport à leur destination.',
    'high',
    'Article 15.1',
    'securite',
    2
),
(
    'OBL-701',
    'Robustesse',
    'Les systèmes d''IA à haut risque doivent être résilients en ce qui concerne les erreurs, les défauts ou les incohérences pouvant survenir dans le système ou son environnement.',
    'high',
    'Article 15.2',
    'securite',
    2
),
(
    'OBL-702',
    'Cybersécurité',
    'Les systèmes d''IA à haut risque doivent être résilients contre les tentatives d''altération de leur utilisation ou de leurs performances par des tiers non autorisés.',
    'high',
    'Article 15.3',
    'securite',
    2
);

-- ==================== ENREGISTREMENT (Article 49) ====================

INSERT INTO obligations (code, title, description, risk_level, article_reference, category, priority) VALUES
(
    'OBL-800',
    'Enregistrement dans la base de données de l''UE',
    'Avant de mettre sur le marché ou de mettre en service un système d''IA à haut risque, le fournisseur ou son mandataire enregistre ce système dans la base de données de l''UE.',
    'high',
    'Article 49.1',
    'enregistrement',
    2
),
(
    'OBL-801',
    'Mise à jour de l''enregistrement',
    'Mise à jour des informations contenues dans l''enregistrement en cas de modification substantielle du système d''IA.',
    'high',
    'Article 49.3',
    'enregistrement',
    2
);

-- ============================================================================
-- 5. DONNÉES D'EXEMPLE (OPTIONNEL - pour tests)
-- ============================================================================

-- Entreprise exemple
INSERT INTO companies (id, name, sector, ai_system_type) VALUES
('company-demo-001', 'TechnoIA Solutions', 'sante', 'Système d''aide au diagnostic médical'),
('company-demo-002', 'FinanceAI Corp', 'finance', 'Analyse prédictive des risques'),
('company-demo-003', 'EduBot SAS', 'education', 'Chatbot pédagogique');

-- Diagnostic exemple (risque élevé)
INSERT INTO diagnostics (id, company_id, session_token, status, score, risk_level, has_unacceptable_practices, completed_at) VALUES
('diag-demo-001', 'company-demo-001', 'session-abc123', 'completed', 75, 'high', 0, datetime('now'));

-- Réponses exemple
INSERT INTO diagnostic_answers (diagnostic_id, question_id, answer) VALUES
('diag-demo-001', 'q1', 'no'),
('diag-demo-001', 'q2', 'yes'),
('diag-demo-001', 'q3', 'yes'),
('diag-demo-001', 'q4', 'yes'),
('diag-demo-001', 'q5', 'no');

-- Obligations assignées au diagnostic
INSERT INTO diagnostic_obligations (diagnostic_id, obligation_id) 
SELECT 'diag-demo-001', id FROM obligations WHERE risk_level = 'high';

-- ============================================================================
-- 6. VUES UTILES
-- ============================================================================

-- Vue : Statistiques des diagnostics par niveau de risque
CREATE VIEW v_diagnostics_stats AS
SELECT 
    risk_level,
    COUNT(*) as total_diagnostics,
    AVG(score) as avg_score,
    COUNT(CASE WHEN has_unacceptable_practices = 1 THEN 1 END) as count_unacceptable
FROM diagnostics
WHERE status = 'completed'
GROUP BY risk_level;

-- Vue : Demandes de devis en attente
CREATE VIEW v_pending_quotes AS
SELECT 
    cr.id,
    cr.full_name,
    cr.email,
    cr.company_name,
    d.risk_level,
    d.score,
    cr.created_at
FROM contact_requests cr
LEFT JOIN diagnostics d ON cr.diagnostic_id = d.id
WHERE cr.status = 'pending'
ORDER BY cr.created_at DESC;

-- Vue : Obligations par catégorie
CREATE VIEW v_obligations_by_category AS
SELECT 
    category,
    COUNT(*) as total_obligations,
    COUNT(CASE WHEN priority = 3 THEN 1 END) as critical_count,
    COUNT(CASE WHEN priority = 2 THEN 1 END) as high_count
FROM obligations
WHERE is_active = 1
GROUP BY category;

-- ============================================================================
-- 7. TRIGGERS (Mise à jour automatique)
-- ============================================================================

-- Trigger : Mise à jour automatique de updated_at pour users
CREATE TRIGGER update_users_timestamp 
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    UPDATE users SET updated_at = datetime('now') WHERE id = OLD.id;
END;

-- Trigger : Mise à jour automatique de updated_at pour companies
CREATE TRIGGER update_companies_timestamp 
AFTER UPDATE ON companies
FOR EACH ROW
BEGIN
    UPDATE companies SET updated_at = datetime('now') WHERE id = OLD.id;
END;

-- Trigger : Mise à jour automatique de updated_at pour obligations
CREATE TRIGGER update_obligations_timestamp 
AFTER UPDATE ON obligations
FOR EACH ROW
BEGIN
    UPDATE obligations SET updated_at = datetime('now') WHERE id = OLD.id;
END;

-- ============================================================================
-- 8. REQUÊTES UTILES COMMENTÉES
-- ============================================================================

-- Obtenir tous les diagnostics avec détails entreprise
-- SELECT d.*, c.name as company_name, c.sector 
-- FROM diagnostics d 
-- LEFT JOIN companies c ON d.company_id = c.id 
-- WHERE d.status = 'completed';

-- Obtenir les obligations pour un diagnostic spécifique
-- SELECT o.* 
-- FROM obligations o
-- INNER JOIN diagnostic_obligations do ON o.id = do.obligation_id
-- WHERE do.diagnostic_id = 'votre-diagnostic-id';

-- Statistiques des demandes de devis par statut
-- SELECT status, COUNT(*) as count 
-- FROM contact_requests 
-- GROUP BY status;

-- Taux de complétion des diagnostics
-- SELECT 
--     COUNT(CASE WHEN status = 'completed' THEN 1 END) * 100.0 / COUNT(*) as completion_rate
-- FROM diagnostics;

-- ============================================================================
-- FIN DU SCRIPT SQL
-- ============================================================================

-- Vérification de l'intégrité
PRAGMA integrity_check;