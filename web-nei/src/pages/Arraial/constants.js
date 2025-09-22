import config from "config";

export const POLLING_INTERVAL = Math.max(
  60000,
  (config.ARRAIAL && config.ARRAIAL.POLLING_INTERVAL) || 10000
);
export const LOG_PAGE_SIZE = 100;
export const MILESTONE_INTERVAL = 50;


