# n8n HA Addon

This is a Home Assistant addon that runs an instance of [n8n](https://n8n.io/), a powerful workflow automation tool. It allows you to automate tasks and integrate various services directly within your Home Assistant environment.

## Features

- Runs n8n on port `5678` with a customizable webhook URL.
- Persistent storage for configuration and data in `/data/n8n_data`.
- Supports environment variable customization through the addon configuration.
- Debug logging enabled for troubleshooting.

## Installation

1. **Add the Repository**:
   - In Home Assistant, go to **Supervisor > Add-on Store**.
   - Click the three dots (⋮) in the top right corner and select **Repositories**.
   - Add the following URL: `https://github.com/echavet/n8n_ha_addon`.
   - Click **Add**.

2. **Install the Addon**:
   - Find **n8n HA Addon** in the Add-on Store.
   - Click **Install** and wait for the installation to complete.

3. **Configure the Addon**:
   - Go to the **Configuration** tab of the addon.
   - Set the `webhook_url` to your desired URL (e.g., `https://n8n.yourdomain.com`).
   - Optionally, add custom environment variables under `env` (e.g., `N8N_LOG_LEVEL=debug`).
   - Save the configuration.

4. **Start the Addon**:
   - Go to the **Info** tab and click **Start**.
   - Check the **Log** tab to ensure it starts correctly.

## Usage

- Access the n8n web interface at the configured `webhook_url` (default: `http://<your-ha-ip>:5678`).
- Use n8n to create workflows, leveraging its extensive node library to automate tasks with Home Assistant and other services.

### Persistent Data
- Configuration and runtime data (e.g., `.env`, encryption key in `.n8n/config`) are stored in `/data/n8n_data`, which is mapped to `/mnt/data/supervisor/addons/data/950c88c9_n8n-ha-addon/n8n_data` on the host.
- This ensures that your workflows and settings persist across restarts.

### Logs
- Debug logs are enabled by default (`bashio::log.level "debug"`) for both initialization and runtime.
- View logs in the Home Assistant UI under **Supervisor > Add-ons > n8n HA Addon > Logs**.

## Configuration Options

| Option         | Description                                      | Default Value            |
|----------------|--------------------------------------------------|--------------------------|
| `webhook_url`  | URL where n8n will be accessible                | `http://localhost:5678`  |
| `env`          | List of custom environment variables for n8n    | `N8N_LOG_LEVEL=debug`<br>`N8N_PORT=5678` |

Example configuration in Home Assistant:
```yaml
webhook_url: "https://n8n.yourdomain.com"
env:
  - "N8N_LOG_LEVEL=debug"
  - "N8N_PORT=5678"
  - "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true"
