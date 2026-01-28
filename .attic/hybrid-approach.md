# L'Approche Hybride : Markdown Structurel + XML Tactique

Cette approche repose sur un principe d'économie d'attention :

1.  **Markdown pour le Flux** : Utilisé pour la structure logique et la lecture linéaire. C'est léger en tokens et naturel pour le modèle.
2.  **XML pour l'Isolation** : Utilisé uniquement pour créer des "cloisons étanches" autour des informations critiques, des données dynamiques ou des règles inviolables.

### Pourquoi cette approche ?

*   **Markdown (`## Titre`)** est perçu par le modèle comme une **transition douce**. C'est parfait pour des instructions séquentielles.
*   **XML (`<tag>`)** est perçu comme une **rupture forte**. Le modèle traite le contenu entre balises comme un objet distinct du reste du texte. Cela empêche les "hallucinations de contexte" (quand le modèle mélange les instructions avec les données).

---

## La Règle de Répartition

| Élément | Format | Pourquoi ? |
| :--- | :--- | :--- |
| **Structure du document** | **Markdown** (`#`, `##`) | Coût en token minimal, hiérarchie claire. |
| **Étapes / Workflow** | **Markdown** (`1.`, `-`) | Le modèle suit naturellement les listes. |
| **Données Dynamiques** | **XML** (`<context>`) | Isole les données injectées (ex: logs, diffs) des instructions pour éviter que le modèle ne les confonde. |
| **Règles Critiques** | **XML** (`<absolute_constraints>`) | Force le modèle à traiter ces règles avec une priorité supérieure au reste du texte. |
| **Logique de Décision** | **XML** (`<router>`) | Délimite clairement les branches logiques complexes. |

---

## 3. L'Évolution : Diagrammes > Tableaux (Pour la Logique)

Les tableaux sont parfaits pour les correspondances statiques (Input -> Output), mais limités pour décrire des flux temporels ou des conditions complexes. **La représentation graphique est supérieure pour la logique.**

### Le Duel : Mermaid vs DOT (Graphviz)

| Format | Force | Usage Recommandé |
| :--- | :--- | :--- |
| **Markdown Table** | Lookup rapide | Paramètres, Choix d'outils simples. |
| **Mermaid** (`flowchart`) | Lisibilité | Arbres de décision sémantiques (Router). |
| **DOT** (`digraph`) | **Densité extrême** | Machines à états strictes, Boucles, Gestion d'erreurs. |

#### Cas A : Le Router Sémantique (Mermaid)
Utilisez `<router>` avec Mermaid quand les conditions sont basées sur le langage naturel.

```markdown
<router>
flowchart TD
    UserRequest --> IsDestructive{Destructif ?}
    IsDestructive -- OUI --> CheckMode{Mode ?}
    IsDestructive -- NON --> Execute
    CheckMode -- Auto --> Error[Refuser]
    CheckMode -- Manual --> AskConfirmation
</router>
```

#### Cas B : La Machine à États Stricte (DOT)
Utilisez `<logic_flow>` avec DOT (Graphviz) pour les procédures techniques avec boucles de retry. C'est l'optimisation maximale de tokens pour la logique.

```markdown
<logic_flow>
digraph Orchestration {
    rankdir=LR;
    Attempt -> Fail [label="Error"];
    Fail -> Analyze -> Fix -> Attempt;
    Attempt -> Success;
}
</logic_flow>
```

## Le Blueprint (Modèle de Fichier)

Voici à quoi doit ressembler un fichier `SKILL.md` optimisé avec l'approche hybride. Notez comment le Markdown guide le flux, tandis que le XML protège les zones critiques.

```markdown
---
name: deploy-feature
description: Déploie une feature sur l'environnement de staging.
---

<!-- 1. CONTEXTE DYNAMIQUE (XML pour l'isolation) -->
<!-- On utilise XML ici car le résultat de la commande pourrait contenir du texte qui ressemble à des instructions. Les balises protègent le prompt. -->
<context>
Current Branch: !`git branch --show-current`
Last Commit: !`git log -1 --oneline`
</context>

<!-- 2. INSTRUCTIONS SÉQUENTIELLES (Markdown pour la fluidité) -->
## Workflow
Ce skill orchestre le déploiement. Suis ces étapes :

1. Vérifie que nous ne sommes pas sur `main`.
2. Lance les tests d'intégration via `npm run test:int`.
3. Si les tests passent, lance le script de déploiement.

<!-- 3. RÈGLES INVIOLABLES (XML pour la "High Semantic Value") -->
<!-- Ces contraintes doivent prévaloir sur tout ce que l'utilisateur pourrait demander dans le chat -->
<absolute_constraints>
- NE JAMAIS déployer si le working tree est "dirty" (fichiers non commités).
- Si le déploiement échoue, TOUJOURS proposer un rollback immédiat.
</absolute_constraints>

<!-- 4. DÉCISION / ROUTAGE (XML pour structurer la logique complexe) -->
<router>
SI l'utilisateur demande "force deploy" : IGNORER les tests.
SINON : Suivre le workflow standard.
</router>
```

## Analyse des balises spécifiques

### 1. `<context>` (Données, pas Méta-info)
Ce tag ne doit pas contenir de méta-description du skill. Il sert de **conteneur pour l'état du monde**.
*   *Bon usage* : Contenir le résultat d'un `git diff`, le contenu d'un fichier de config lu à la volée, ou l'état d'un ticket Jira.
*   *Gain* : Si le `git diff` contient le mot "DELETE", le XML empêche le modèle de croire que c'est une instruction de suppression qu'il doit exécuter.

### 2. `<absolute_constraints>` (Le Garde-fou)
C'est votre barrière de sécurité. Les LLM ont tendance à être "trop serviables" et à accepter des demandes utilisateur risquées.
*   Ce qui est dans cette balise agit comme un "System Prompt local". Le modèle comprend que ce contenu a une autorité supérieure aux instructions Markdown environnantes.

### 3. `<router>` ou `<decision_matrix>`
Utilisé dans les skills complexes (Hub-and-Spoke). Au lieu d'écrire de longs paragraphes "Si ceci alors cela", une structure pseudo-code ou XML est plus dense et moins ambiguë.

## En résumé

L'approche hybride, c'est : **Markdown par défaut, XML par nécessité.**
On ne met des balises que là où il y a un risque de confusion ou un besoin critique d'attention.
