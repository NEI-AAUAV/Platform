import config from "config";

/**
 * Global Arraial enable state: prioritize config, but allow API override
 * @param {boolean|null} apiEnabled - The enabled state from API (null, true, false)
 * @returns {boolean} - Whether Arraial should be enabled
 */
export function getEnableArraial(apiEnabled = null) {
  // If config is enabled, always enable
  if (config.ENABLE_ARRAIAL) {
    return true;
  }
  
  // If config is disabled, only enable if API explicitly says true
  return apiEnabled === true;
}

/**
 * Check if Arraial route should be registered
 * @returns {boolean} - Whether the route should exist
 */
export function shouldRegisterArraialRoute() {
  return config.ENABLE_ARRAIAL;
}
