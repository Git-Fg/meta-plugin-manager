---
name: claude-cli-non-interactive
description: "Guide complet pour utiliser Claude Code CLI en mode impression (-p) et tester des skills/plugins/subagents de manière autonome dans un environnement isolé"
---

# Claude CLI Non-Interactif

## Objectif
Utiliser Claude Code en mode impression (-p) pour automatiser les workflows, tester des skills et valider leur autonomie complète sans supervision humaine.

## Quand Utiliser
- Tests automatisés de skills et plugins
- Validation de l'autonomie des workflows (80-95% completion)
- Orchestration de tâches complexes via scripts
- Revue de logs et analyse de performance
- Création d'environnements de test isolés

## Workflow Principal

### Pattern de Test Isolé

```bash
# Créer un dossier local et exécuter Claude depuis ce dossier
mkdir test-name && cd test-name && claude -p "your query here"
```

### Exemples

```bash
# Test basique d'une skill
mkdir skill-test && cd skill-test && claude -p "Listez les skills disponibles" --max-turns 5

# Test avec budget limité
mkdir autonomy-test && cd autonomy-test && claude -p "Créez un README.md sans poser de questions" --max-turns 5 --max-budget-usd 2.00

# Test avec sortie JSON
mkdir json-test && cd json-test && claude -p "Analysez ce projet" --output-format json > result.json
```

## Commandes CLI Essentielles

### Mode Impression (-p)
```bash
# Syntaxe de base
claude -p "votre_query" [options]

# Sortie JSON pour analyse programmée
claude -p "query" --output-format json

# Limitation budgétaire
claude -p "query" --max-budget-usd 5.00

# Limitation des tours
claude -p "query" --max-turns 10
```

### Drapeaux Cruciaux pour les Tests

```bash
# Persistance désactivée (tests isolés)
--no-session-persistence

# Sortie structurée
--output-format json
--include-partial-messages

# Débogage
--verbose
--debug "api,hooks"

# Modèle spécifique
--model sonnet
--fallback-model haiku

# Outils restreints
--tools "Bash,Read,Edit"
--disallowedTools "Write"
```

## Analyse des Logs et Performance

### Stratégie de Revue

```bash
# Capture complète des logs
claude -p "query" --verbose 2>&1 | tee full-log.txt

# Filtrage par importance
grep -E "(ERROR|WARN|SUCCESS|TOOL_CALL)" full-log.txt > filtered-log.txt

# Analyse temporelle
grep -E "timestamp|took [0-9]+ms" full-log.txt > timing-log.txt
```

### Métriques Clés à Surveiller

1. **Autonomie**: Nombre de questions posées
   ```bash
   # Ideal: <3 questions pour 95% de completion
   grep -c "?" questions.log
   ```

2. **Efficacité**: Tours nécessaires vs objectif
   ```bash
   # Ratio: tours_actual / tours_max
   grep "max_turns" summary.log
   ```

3. **Coût**: Budget dépensé vs alloué
   ```bash
   # Comparaison
   cat budget-report.txt
   ```

## Patterns de Test pour Skills

### Test d'Autonomie
```bash
mkdir autonomy-test && cd autonomy-test && claude -p "Traitez le fichier data.csv sans poser de questions" --max-turns 10 --max-budget-usd 2.00
```

### Test de Robustesse
```bash
mkdir robustness-test && cd robustness-test && claude -p "Testez la skill file-analyzer avec des fichiers manquants et vides" --verbose
```

### Test de Performance
```bash
mkdir perf-test && cd perf-test && time claude -p "Analysez tous les fichiers du projet" --max-turns 15
```

## Validation de l'Autonomie (Critères 80-95%)

### Checklist d'Autonomie

✅ **Score 95% - Excellence**
- 0-1 questions maximum
- Exécution complète de A à Z
- Gestion automatique des erreurs
- Choix optimaux sans guidance

✅ **Score 85% - Bon**
- 2-3 questions acceptables
- Complétion de 90% de la tâche
- Quelques validations mineures

✅ **Score 80% - Minimum Acceptable**
- 4-5 questions maximum
- 80% d'exécution autonome
- Clarifications sur contexte critique

### Script de Scoring Automatique
```bash
#!/bin/bash
# calc-autonomy-score.sh

LOG_FILE="$1"
QUESTIONS=$(grep -c "?" "$LOG_FILE")
TOOL_CALLS=$(grep -c "TOOL_CALL" "$LOG_FILE")
COMPLETION_RATE=$(grep -o "completion_rate: [0-9]*" "$LOG_FILE" | cut -d' ' -f2)

# Score calculation
if [ "$QUESTIONS" -le 1 ]; then
  AUTONOMY_SCORE=95
elif [ "$QUESTIONS" -le 3 ]; then
  AUTONOMY_SCORE=85
elif [ "$QUESTIONS" -le 5 ]; then
  AUTONOMY_SCORE=80
else
  AUTONOMY_SCORE=70
fi

echo "Score d'Autonomie: ${AUTONOMY_SCORE}%"
echo "Questions posées: $QUESTIONS"
echo "Appels d'outils: $TOOL_CALLS"

if [ "$AUTONOMY_SCORE" -ge 80 ]; then
  echo "✅ VALIDÉ: Skill suffisamment autonome"
  exit 0
else
  echo "❌ ÉCHEC: Skill nécessite des améliorations"
  exit 1
fi
```

## Orchestration Multi-Skills

### Pattern de Hub-and-Spoke
```bash
# Hub skill orchestre les sub-skills
claude -p "
Hub Skill: Orchestration de data-pipeline
1. Détecter le type de données
2. Sélectionner skill appropriée:
   - 'csv-processor' pour données tabulaires
   - 'json-analyzer' pour données hiérarchiques
   - 'text-miner' pour données non-structurées
3. Exécuter la skill choisie
4. Agréger les résultats
" \
  --max-turns 25 \
  --output-format json
```

### Validation des Chaînes de Skills
```bash
# Test de la chaîne complète
for i in {1..5}; do
  echo "=== Test Round $i ==="
  claude -p "Exécutez la chaîne skill1 → skill2 → skill3" \
    --max-turns 30 \
    --session-id "test-chain-$i" \
    --output-format json > chain-test-$i.json

  # Vérifier l'intégrité
  jq '.success' chain-test-$i.json
done
```

## Bonnes Pratiques pour Tests Automatisés

### Isolation par Test
```bash
# Un dossier = un test
mkdir test-phase1-skill-chain && cd test-phase1-skill-chain && claude -p "Testez la chaîne skill-a → skill-b"
mkdir test-phase2-forked && cd test-phase2-forked && claude -p "Testez l'isolation des forked skills"
```

### Reproductibilité
```bash
mkdir reproducible-test && cd reproducible-test && claude -p "Query" --session-id "test-001"
```

### Analyse de Résultat
```bash
mkdir json-output && cd json-output && claude -p "Query" --output-format json > result.json && jq '.success' result.json
```

## Extraction d'Enseignements

### Pattern d'Itération
```bash
# Cycle: Test → Analyse → Amélioration → Re-test
for iteration in {1..3}; do
  echo "=== Itération $iteration ==="

  # Test
  claude -p "query" --verbose 2>&1 | tee iteration-$iteration.log

  # Analyse automatique
  ./analyze-autonomy.sh iteration-$iteration.log > analysis-$iteration.txt

  # Amélioration basée sur l'analyse
  if [ -f "improvements-$iteration.txt" ]; then
    apply-improvements.sh improvements-$iteration.txt
  fi
done
```

### Rapport Final
```bash
# Génération du rapport de validation
cat > test-report.md <<EOF
# Rapport de Test - Skill Validation

## Métriques Globales
- Tests effectués: $TOTAL_TESTS
- Taux de réussite: $SUCCESS_RATE%
- Score d'autonomie moyen: $AVG_AUTONOMY%
- Coût moyen par test: $AVG_COST$

## Points d'Amélioration
$(cat improvements-summary.txt)

## Recommandations
$(cat recommendations.txt)
EOF
```

## URLs de Référence

### Documentation Officielle
- **Claude Code CLI**: https://code.claude.com/docs/en/cli
- **Agent SDK**: https://docs.claude.com/en/docs/agent-sdk
- **Skills Documentation**: https://code.claude.com/docs/en/skills
- **Agent Skills Spec**: https://agentskills.io/specification

### Exemples et Patterns
- **MCP Integration**: https://code.claude.com/docs/en/mcp
- **Sub-agents**: https://code.claude.com/docs/en/sub-agents
- **Hooks System**: https://code.claude.com/docs/en/hooks

## Conseils de Debugging

### Mode Verbose
```bash
# Logs détaillés pour diagnostic
claude -p "query" --verbose --debug "api,hooks,tools"
```

### Analyse des Échecs
```bash
# Identifier les points d'échec
grep -E "(ERROR|FAIL|Exception)" full-log.txt

# Examiner les dernières actions
tail -50 full-log.txt
```

### Optimisation
```bash
# Ajuster selon les logs
# - Réduire max_turns si trop long
# - Augmenter budget si timeout
# - Réduire complexité si questions excessives
```

## Conclusion

L'utilisation de Claude CLI en mode non-interactif permet la validation systématique et l'amélioration continue des skills. En suivant ces patterns, vous garantissez une autonomie de 80-95% et une exécution fiable pour l'automatisation.

**Points Clés**:
- Toujours tester dans un environnement isolé
- Valider l'autonomie avec des métriques quantifiables
- Itérer basée sur l'analyse des logs
- Documenter les patterns qui fonctionnent

---
*Skill créée pour l'utilisation autonome de Claude Code CLI en mode impression (-p)*
