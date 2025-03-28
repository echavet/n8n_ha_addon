
---

### Fichier : `README.fr.md` (Français)

```markdown
# Addon n8n pour Home Assistant

Cet addon pour Home Assistant exécute une instance de [n8n](https://n8n.io/), un outil puissant d’automatisation de workflows. Il vous permet d’automatiser des tâches et d’intégrer divers services directement dans votre environnement Home Assistant.

## Fonctionnalités

- Exécute n8n sur le port `5678` avec une URL de webhook personnalisable.
- Stockage persistant pour la configuration et les données dans `/data/n8n_data`.
- Prise en charge des variables d’environnement personnalisées via la configuration de l’addon.
- Logs de débogage activés pour faciliter le dépannage.

## Installation

1. **Ajouter le dépôt** :
   - Dans Home Assistant, allez à **Superviseur > Boutique d’add-ons**.
   - Cliquez sur les trois points (⋮) en haut à droite et sélectionnez **Dépôts**.
   - Ajoutez l’URL suivante : `https://github.com/echavet/n8n_ha_addon`.
   - Cliquez sur **Ajouter**.

2. **Installer l’addon** :
   - Trouvez **n8n HA Addon** dans la boutique d’add-ons.
   - Cliquez sur **Installer** et attendez la fin de l’installation.

3. **Configurer l’addon** :
   - Allez dans l’onglet **Configuration** de l’addon.
   - Définissez `webhook_url` avec l’URL souhaitée (ex. `https://n8n.votredomaine.com`).
   - Ajoutez éventuellement des variables d’environnement personnalisées sous `env` (ex. `N8N_LOG_LEVEL=debug`).
   - Sauvegardez la configuration.

4. **Démarrer l’addon** :
   - Allez dans l’onglet **Info** et cliquez sur **Démarrer**.
   - Vérifiez l’onglet **Logs** pour vous assurer qu’il démarre correctement.

## Utilisation

- Accédez à l’interface web de n8n via l’URL configurée dans `webhook_url` (par défaut : `http://<votre-ip-ha>:5678`).
- Utilisez n8n pour créer des workflows, en tirant parti de sa vaste bibliothèque de nœuds pour automatiser des tâches avec Home Assistant et d’autres services.

### Données persistantes

- Les données de configuration et d’exécution (ex. `.env`, clé de chiffrement dans `.n8n/config`) sont stockées dans `/data/n8n_data`, mappé à `/mnt/data/supervisor/addons/data/950c88c9_n8n-ha-addon/n8n_data` sur l’hôte.
- Cela garantit que vos workflows et paramètres persistent entre les redémarrages.

### Logs

- Les logs de débogage sont activés par défaut (`bashio::log.level "debug"`) pour l’initialisation et l’exécution.
- Consultez les logs dans l’interface Home Assistant sous **Superviseur > Add-ons > n8n HA Addon > Logs**.

## Options de configuration

| Option         | Description                                      | Valeur par défaut        |
|----------------|--------------------------------------------------|--------------------------|
| `webhook_url`  | URL où n8n sera accessible                      | `http://localhost:5678`  |
| `env`          | Liste de variables d’environnement personnalisées pour n8n | `N8N_LOG_LEVEL=debug`<br>`N8N_PORT=5678` |

Exemple de configuration dans Home Assistant :

```yaml
webhook_url: "https://n8n.votredomaine.com"
env:
  - "N8N_LOG_LEVEL=debug"
  - "N8N_PORT=5678"
  - "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true"
