"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
var react_1 = require("react");
var lucide_react_1 = require("lucide-react");
var RiaCheckGoApp = function () {
    var _a = (0, react_1.useState)('home'), currentScreen = _a[0], setCurrentScreen = _a[1];
    var _b = (0, react_1.useState)(false), menuOpen = _b[0], setMenuOpen = _b[1];
    var _c = (0, react_1.useState)({
        companyName: '',
        sector: '',
        aiType: '',
        riskAnswers: {},
        contactName: '',
        email: '',
        phone: ''
    }), formData = _c[0], setFormData = _c[1];
    var _d = (0, react_1.useState)(0), diagnosticStep = _d[0], setDiagnosticStep = _d[1];
    // Questions du diagnostic
    var diagnosticQuestions = [
        {
            id: 'q1',
            question: 'Votre système d\'IA utilise-t-il des techniques de manipulation subliminale ?',
            category: 'interdiction',
            risk: 'inacceptable'
        },
        {
            id: 'q2',
            question: 'Votre système d\'IA est-il utilisé dans un contexte critique (santé, transports, éducation) ?',
            category: 'risque_eleve',
            risk: 'high'
        },
        {
            id: 'q3',
            question: 'Votre système traite-t-il des données biométriques ?',
            category: 'donnees_sensibles',
            risk: 'high'
        },
        {
            id: 'q4',
            question: 'Votre système interagit-il directement avec des utilisateurs sans supervision humaine ?',
            category: 'transparence',
            risk: 'medium'
        },
        {
            id: 'q5',
            question: 'Disposez-vous d\'une documentation technique complète de votre système ?',
            category: 'documentation',
            risk: 'compliance'
        }
    ];
    // Calcul du score et du niveau de risque
    var calculateRiskScore = function () {
        var answers = formData.riskAnswers;
        var score = 0;
        var riskLevel = 'minimal';
        var blockers = [];
        diagnosticQuestions.forEach(function (q) {
            if (answers[q.id] === 'yes') {
                if (q.risk === 'inacceptable') {
                    blockers.push('Pratiques interdites détectées (Art. 5 RIA)');
                    riskLevel = 'inacceptable';
                }
                else if (q.risk === 'high') {
                    score += 30;
                    if (riskLevel !== 'inacceptable')
                        riskLevel = 'high';
                }
                else if (q.risk === 'medium') {
                    score += 15;
                    if (riskLevel === 'minimal')
                        riskLevel = 'medium';
                }
            }
            if (answers[q.id] === 'no' && q.risk === 'compliance') {
                score -= 20;
            }
        });
        return { score: Math.min(100, Math.max(0, score)), riskLevel: riskLevel, blockers: blockers };
    };
    // Navigation
    var NavigationBar = function () { return (<nav className="bg-indigo-700 text-white p-4 shadow-lg">
      <div className="max-w-6xl mx-auto flex items-center justify-between">
        <div className="flex items-center space-x-2">
          <lucide_react_1.Shield className="w-8 h-8"/>
          <div>
            <h1 className="text-xl font-bold">RIA Check & Go</h1>
            <p className="text-xs text-indigo-200">by Webside</p>
          </div>
        </div>
        <button onClick={function () { return setMenuOpen(!menuOpen); }} className="lg:hidden">
          {menuOpen ? <lucide_react_1.X /> : <lucide_react_1.Menu />}
        </button>
        <div className="hidden lg:flex space-x-4">
          <button onClick={function () { return setCurrentScreen('home'); }} className="hover:text-indigo-200">Accueil</button>
          <button onClick={function () { return setCurrentScreen('diagnostic'); }} className="hover:text-indigo-200">Diagnostic</button>
          <button onClick={function () { return setCurrentScreen('about'); }} className="hover:text-indigo-200">À propos</button>
        </div>
      </div>
      {menuOpen && (<div className="lg:hidden mt-4 space-y-2">
          <button onClick={function () { setCurrentScreen('home'); setMenuOpen(false); }} className="block w-full text-left py-2">Accueil</button>
          <button onClick={function () { setCurrentScreen('diagnostic'); setMenuOpen(false); }} className="block w-full text-left py-2">Diagnostic</button>
          <button onClick={function () { setCurrentScreen('about'); setMenuOpen(false); }} className="block w-full text-left py-2">À propos</button>
        </div>)}
    </nav>); };
    // Écran 1: Page d'accueil
    var HomeScreen = function () { return (<div className="min-h-screen bg-gradient-to-br from-indigo-50 to-blue-100">
      <NavigationBar />
      <div className="max-w-4xl mx-auto p-6 pt-12">
        <div className="bg-white rounded-2xl shadow-xl p-8 mb-6">
          <div className="text-center mb-8">
            <div className="inline-block p-4 bg-indigo-100 rounded-full mb-4">
              <lucide_react_1.Shield className="w-16 h-16 text-indigo-600"/>
            </div>
            <h2 className="text-3xl font-bold text-gray-800 mb-4">
              Bienvenue sur RIA Check & Go
            </h2>
            <p className="text-lg text-gray-600 mb-6">
              Votre assistant intelligent pour la conformité au Règlement sur l'IA (AI Act)
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-6 mb-8">
            <div className="p-6 bg-indigo-50 rounded-xl">
              <lucide_react_1.BarChart3 className="w-10 h-10 text-indigo-600 mb-3"/>
              <h3 className="font-semibold text-gray-800 mb-2">Diagnostic Rapide</h3>
              <p className="text-sm text-gray-600">Évaluez le niveau de risque de votre système d'IA en quelques minutes</p>
            </div>
            <div className="p-6 bg-green-50 rounded-xl">
              <lucide_react_1.FileText className="w-10 h-10 text-green-600 mb-3"/>
              <h3 className="font-semibold text-gray-800 mb-2">Rapport Détaillé</h3>
              <p className="text-sm text-gray-600">Recevez un rapport PDF personnalisé avec vos obligations</p>
            </div>
            <div className="p-6 bg-purple-50 rounded-xl">
              <lucide_react_1.Shield className="w-10 h-10 text-purple-600 mb-3"/>
              <h3 className="font-semibold text-gray-800 mb-2">Accompagnement Expert</h3>
              <p className="text-sm text-gray-600">Bénéficiez de notre expertise pour votre mise en conformité</p>
            </div>
          </div>

          <div className="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-xl p-8 text-white mb-6">
            <h3 className="text-2xl font-bold mb-3">Pourquoi la conformité RIA est essentielle ?</h3>
            <ul className="space-y-2">
              <li className="flex items-start">
                <lucide_react_1.Check className="w-5 h-5 mr-2 mt-1 flex-shrink-0"/>
                <span>Obligatoire pour les systèmes d'IA à haut risque dès 2025</span>
              </li>
              <li className="flex items-start">
                <lucide_react_1.Check className="w-5 h-5 mr-2 mt-1 flex-shrink-0"/>
                <span>Évitez des amendes pouvant atteindre 35M€ ou 7% du CA</span>
              </li>
              <li className="flex items-start">
                <lucide_react_1.Check className="w-5 h-5 mr-2 mt-1 flex-shrink-0"/>
                <span>Garantissez la confiance de vos utilisateurs et partenaires</span>
              </li>
            </ul>
          </div>

          <button onClick={function () { return setCurrentScreen('diagnostic'); }} className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-4 px-6 rounded-xl flex items-center justify-center space-x-2 transition-all transform hover:scale-105">
            <span>Commencer le diagnostic gratuit</span>
            <lucide_react_1.ChevronRight className="w-5 h-5"/>
          </button>
        </div>

        <div className="text-center text-gray-600 text-sm">
          <p>Développé par Webside - Expert en conformité réglementaire</p>
        </div>
      </div>
    </div>); };
    // Écran 2: Diagnostic / Questionnaire
    var DiagnosticScreen = function () {
        var progress = ((diagnosticStep + 1) / (diagnosticQuestions.length + 2)) * 100;
        return (<div className="min-h-screen bg-gradient-to-br from-indigo-50 to-blue-100">
        <NavigationBar />
        <div className="max-w-3xl mx-auto p-6 pt-12">
          <div className="bg-white rounded-2xl shadow-xl p-8">
            {/* Progress Bar */}
            <div className="mb-8">
              <div className="flex justify-between text-sm text-gray-600 mb-2">
                <span>Progression</span>
                <span>{Math.round(progress)}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div className="bg-indigo-600 h-3 rounded-full transition-all duration-500" style={{ width: "".concat(progress, "%") }}></div>
              </div>
            </div>

            {/* Step 0: Company Info */}
            {diagnosticStep === 0 && (<div>
                <h2 className="text-2xl font-bold text-gray-800 mb-6">Informations sur votre entreprise</h2>
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Nom de l'entreprise *</label>
                    <input type="text" value={formData.companyName} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { companyName: e.target.value })); }} className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent" placeholder="Votre entreprise"/>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Secteur d'activité *</label>
                    <select value={formData.sector} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { sector: e.target.value })); }} className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
                      <option value="">Sélectionnez...</option>
                      <option value="sante">Santé</option>
                      <option value="finance">Finance</option>
                      <option value="transport">Transport</option>
                      <option value="education">Éducation</option>
                      <option value="autre">Autre</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Type de système d'IA</label>
                    <input type="text" value={formData.aiType} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { aiType: e.target.value })); }} className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500" placeholder="Ex: Système de recommandation, Analyse prédictive..."/>
                  </div>
                </div>
                <button onClick={function () { return formData.companyName && formData.sector && setDiagnosticStep(1); }} disabled={!formData.companyName || !formData.sector} className="w-full mt-6 bg-indigo-600 hover:bg-indigo-700 disabled:bg-gray-300 text-white font-semibold py-3 px-6 rounded-lg flex items-center justify-center space-x-2">
                  <span>Continuer</span>
                  <lucide_react_1.ChevronRight className="w-5 h-5"/>
                </button>
              </div>)}

            {/* Steps 1-5: Questions */}
            {diagnosticStep > 0 && diagnosticStep <= diagnosticQuestions.length && (<div>
                <div className="mb-6">
                  <span className="text-sm text-indigo-600 font-semibold">Question {diagnosticStep}/{diagnosticQuestions.length}</span>
                  <h2 className="text-xl font-bold text-gray-800 mt-2">
                    {diagnosticQuestions[diagnosticStep - 1].question}
                  </h2>
                </div>
                <div className="space-y-3">
                  <button onClick={function () {
                    var _a;
                    var qId = diagnosticQuestions[diagnosticStep - 1].id;
                    setFormData(__assign(__assign({}, formData), { riskAnswers: __assign(__assign({}, formData.riskAnswers), (_a = {}, _a[qId] = 'yes', _a)) }));
                    setTimeout(function () { return setDiagnosticStep(diagnosticStep + 1); }, 300);
                }} className="w-full p-4 border-2 border-gray-300 hover:border-green-500 hover:bg-green-50 rounded-lg text-left transition-all">
                    <div className="flex items-center">
                      <div className="w-6 h-6 border-2 border-gray-400 rounded-full mr-3"></div>
                      <span className="font-medium">Oui</span>
                    </div>
                  </button>
                  <button onClick={function () {
                    var _a;
                    var qId = diagnosticQuestions[diagnosticStep - 1].id;
                    setFormData(__assign(__assign({}, formData), { riskAnswers: __assign(__assign({}, formData.riskAnswers), (_a = {}, _a[qId] = 'no', _a)) }));
                    setTimeout(function () { return setDiagnosticStep(diagnosticStep + 1); }, 300);
                }} className="w-full p-4 border-2 border-gray-300 hover:border-red-500 hover:bg-red-50 rounded-lg text-left transition-all">
                    <div className="flex items-center">
                      <div className="w-6 h-6 border-2 border-gray-400 rounded-full mr-3"></div>
                      <span className="font-medium">Non</span>
                    </div>
                  </button>
                  <button onClick={function () {
                    var _a;
                    var qId = diagnosticQuestions[diagnosticStep - 1].id;
                    setFormData(__assign(__assign({}, formData), { riskAnswers: __assign(__assign({}, formData.riskAnswers), (_a = {}, _a[qId] = 'unknown', _a)) }));
                    setTimeout(function () { return setDiagnosticStep(diagnosticStep + 1); }, 300);
                }} className="w-full p-4 border-2 border-gray-300 hover:border-gray-500 hover:bg-gray-50 rounded-lg text-left transition-all">
                    <div className="flex items-center">
                      <div className="w-6 h-6 border-2 border-gray-400 rounded-full mr-3"></div>
                      <span className="font-medium">Je ne sais pas</span>
                    </div>
                  </button>
                </div>
                <button onClick={function () { return setDiagnosticStep(diagnosticStep - 1); }} className="mt-6 text-indigo-600 hover:text-indigo-800 font-medium">
                  ← Retour
                </button>
              </div>)}

            {/* Step 6: Results */}
            {diagnosticStep > diagnosticQuestions.length && (<div>
                <button onClick={function () { return setCurrentScreen('results'); }} className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-3 px-6 rounded-lg">
                  Voir mes résultats
                </button>
              </div>)}
          </div>
        </div>
      </div>);
    };
    // Écran 3: Résultats et Devis
    var ResultsScreen = function () {
        var _a = calculateRiskScore(), score = _a.score, riskLevel = _a.riskLevel, blockers = _a.blockers;
        var riskConfig = {
            inacceptable: { color: 'red', label: 'Inacceptable', icon: '⛔' },
            high: { color: 'orange', label: 'Élevé', icon: '🔴' },
            medium: { color: 'yellow', label: 'Modéré', icon: '🟡' },
            minimal: { color: 'green', label: 'Minimal', icon: '🟢' }
        };
        var config = riskConfig[riskLevel];
        return (<div className="min-h-screen bg-gradient-to-br from-indigo-50 to-blue-100">
        <NavigationBar />
        <div className="max-w-4xl mx-auto p-6 pt-12">
          <div className="bg-white rounded-2xl shadow-xl p-8 mb-6">
            <h2 className="text-3xl font-bold text-gray-800 mb-6 text-center">
              Résultats de votre diagnostic
            </h2>

            {/* Score Display */}
            <div className="text-center mb-8">
              <div className={"inline-block p-8 bg-".concat(config.color, "-100 rounded-3xl mb-4")}>
                <div className="text-6xl mb-2">{config.icon}</div>
                <div className="text-4xl font-bold text-gray-800">{score}/100</div>
                <div className={"text-xl font-semibold text-".concat(config.color, "-600 mt-2")}>
                  Risque {config.label}
                </div>
              </div>
            </div>

            {/* Blockers Alert */}
            {blockers.length > 0 && (<div className="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                <div className="flex items-start">
                  <lucide_react_1.AlertTriangle className="w-6 h-6 text-red-500 mr-3 flex-shrink-0"/>
                  <div>
                    <h3 className="font-semibold text-red-800 mb-2">⚠️ Pratiques Interdites Détectées</h3>
                    {blockers.map(function (b, i) { return (<p key={i} className="text-red-700">{b}</p>); })}
                  </div>
                </div>
              </div>)}

            {/* Obligations */}
            <div className="space-y-4 mb-8">
              <h3 className="text-xl font-semibold text-gray-800 mb-4">Vos obligations principales :</h3>
              
              {riskLevel === 'high' && (<>
                  <div className="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                    <h4 className="font-semibold text-blue-900 mb-2">📋 Système de gestion des risques (Art. 9)</h4>
                    <p className="text-sm text-blue-800">Documentation continue des risques et mesures d'atténuation</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                    <h4 className="font-semibold text-blue-900 mb-2">📊 Gouvernance des données (Art. 10)</h4>
                    <p className="text-sm text-blue-800">Jeux de données pertinents, représentatifs et sans biais</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                    <h4 className="font-semibold text-blue-900 mb-2">📝 Documentation technique (Annexe IV)</h4>
                    <p className="text-sm text-blue-800">Dossier technique complet du système d'IA</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                    <h4 className="font-semibold text-blue-900 mb-2">🔍 Enregistrement UE</h4>
                    <p className="text-sm text-blue-800">Inscription au registre européen des systèmes IA à haut risque</p>
                  </div>
                </>)}

              {riskLevel === 'medium' && (<div className="p-4 bg-yellow-50 rounded-lg border-l-4 border-yellow-500">
                  <h4 className="font-semibold text-yellow-900 mb-2">💬 Obligations de transparence (Art. 52)</h4>
                  <p className="text-sm text-yellow-800">Information claire aux utilisateurs sur l'usage de l'IA</p>
                </div>)}

              {riskLevel === 'minimal' && (<div className="p-4 bg-green-50 rounded-lg border-l-4 border-green-500">
                  <h4 className="font-semibold text-green-900 mb-2">✅ Obligations limitées</h4>
                  <p className="text-sm text-green-800">Votre système présente un faible niveau de risque. Restez vigilant sur les évolutions réglementaires.</p>
                </div>)}
            </div>

            {/* Download Report */}
            <button className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg flex items-center justify-center space-x-2 mb-4">
              <lucide_react_1.Download className="w-5 h-5"/>
              <span>Télécharger le rapport PDF complet</span>
            </button>

            {/* Contact Form */}
            <div className="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-xl p-6 text-white">
              <h3 className="text-xl font-bold mb-4">Besoin d'accompagnement ?</h3>
              <p className="mb-4">Demandez un devis personnalisé à nos experts Webside</p>
              
              <div className="space-y-3">
                <input type="text" value={formData.contactName} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { contactName: e.target.value })); }} placeholder="Nom complet" className="w-full p-3 rounded-lg text-gray-800"/>
                <input type="email" value={formData.email} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { email: e.target.value })); }} placeholder="Email professionnel" className="w-full p-3 rounded-lg text-gray-800"/>
                <input type="tel" value={formData.phone} onChange={function (e) { return setFormData(__assign(__assign({}, formData), { phone: e.target.value })); }} placeholder="Téléphone" className="w-full p-3 rounded-lg text-gray-800"/>
                <button className="w-full bg-white text-indigo-600 hover:bg-gray-100 font-semibold py-3 px-6 rounded-lg flex items-center justify-center space-x-2">
                  <lucide_react_1.Send className="w-5 h-5"/>
                  <span>Demander un devis gratuit</span>
                </button>
              </div>
            </div>
          </div>

          <div className="text-center">
            <button onClick={function () {
                setCurrentScreen('home');
                setDiagnosticStep(0);
                setFormData({
                    companyName: '',
                    sector: '',
                    aiType: '',
                    riskAnswers: {},
                    contactName: '',
                    email: '',
                    phone: ''
                });
            }} className="text-indigo-600 hover:text-indigo-800 font-medium">
              ← Retour à l'accueil
            </button>
          </div>
        </div>
      </div>);
    };
    // About Screen
    var AboutScreen = function () { return (<div className="min-h-screen bg-gradient-to-br from-indigo-50 to-blue-100">
      <NavigationBar />
      <div className="max-w-4xl mx-auto p-6 pt-12">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          <h2 className="text-3xl font-bold text-gray-800 mb-6">À propos de RIA Check & Go</h2>
          <div className="prose max-w-none">
            <p className="text-gray-700 mb-4">
              RIA Check & Go est une solution développée par <strong>Webside</strong>, entreprise spécialisée dans les services informatiques et la conformité réglementaire.
            </p>
            <p className="text-gray-700 mb-4">
              Notre mission : accompagner les entreprises dans leur mise en conformité avec le Règlement sur l'Intelligence Artificielle (AI Act) de l'Union Européenne.
            </p>
            <h3 className="text-xl font-semibold text-gray-800 mt-6 mb-3">Nos services</h3>
            <ul className="list-disc list-inside space-y-2 text-gray-700">
              <li>Audit de conformité RIA</li>
              <li>Accompagnement à la mise en conformité</li>
              <li>Formation des équipes</li>
              <li>Support technique et juridique</li>
            </ul>
          </div>
          <button onClick={function () { return setCurrentScreen('home'); }} className="mt-8 text-indigo-600 hover:text-indigo-800 font-medium">
            ← Retour à l'accueil
          </button>
        </div>
      </div>
    </div>); };
    // Router
    return (<div className="font-sans">
      {currentScreen === 'home' && <HomeScreen />}
      {currentScreen === 'diagnostic' && <DiagnosticScreen />}
      {currentScreen === 'results' && <ResultsScreen />}
      {currentScreen === 'about' && <AboutScreen />}
    </div>);
};
exports.default = RiaCheckGoApp;
