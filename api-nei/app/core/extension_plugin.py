"""
Extension Plugin Interface

This module provides a base interface for extensions to integrate with the main platform.
"""

from abc import ABC, abstractmethod
from typing import Dict, List, Optional
from fastapi import FastAPI
from loguru import logger


class ExtensionPlugin(ABC):
    """Base class for extension plugins"""
    
    def __init__(self, extension_name: str):
        self.extension_name = extension_name
        self._initialized = False
    
    @property
    def name(self) -> str:
        """Get the extension name"""
        return self.extension_name
    
    @property
    def is_initialized(self) -> bool:
        """Check if plugin has been initialized"""
        return self._initialized
    
    def mark_initialized(self) -> None:
        """Mark plugin as initialized"""
        self._initialized = True
        logger.info(f"Extension plugin '{self.extension_name}' initialized")
    
    @abstractmethod
    def register_scopes(self) -> Dict[str, str]:
        """
        Register scopes provided by this extension
        
        Returns:
            Dictionary mapping scope names to descriptions
        """
        pass
    
    def register_routes(self, app: FastAPI) -> None:
        """
        Register extension routes with the main FastAPI app
        
        Args:
            app: The main FastAPI application instance
        """
        pass
    
    def register_middleware(self, app: FastAPI) -> None:
        """
        Register extension middleware with the main FastAPI app
        
        Args:
            app: The main FastAPI application instance
        """
        pass
    
    def register_startup_events(self, app: FastAPI) -> None:
        """
        Register extension startup events
        
        Args:
            app: The main FastAPI application instance
        """
        pass
    
    def register_shutdown_events(self, app: FastAPI) -> None:
        """
        Register extension shutdown events
        
        Args:
            app: The main FastAPI application instance
        """
        pass


class ExtensionPluginManager:
    """Manager for extension plugins"""
    
    def __init__(self):
        self._plugins: Dict[str, ExtensionPlugin] = {}
        self._initialized = False
    
    def register_plugin(self, plugin: ExtensionPlugin) -> None:
        """
        Register an extension plugin
        
        Args:
            plugin: The extension plugin to register
        """
        if plugin.name in self._plugins:
            logger.warning(f"Plugin '{plugin.name}' already registered, overwriting")
        
        self._plugins[plugin.name] = plugin
        logger.info(f"Registered extension plugin: {plugin.name}")
    
    def get_plugin(self, name: str) -> Optional[ExtensionPlugin]:
        """
        Get a registered plugin by name
        
        Args:
            name: The plugin name
            
        Returns:
            The plugin instance or None if not found
        """
        return self._plugins.get(name)
    
    def get_all_plugins(self) -> Dict[str, ExtensionPlugin]:
        """Get all registered plugins"""
        return self._plugins.copy()
    
    def initialize_plugin(self, name: str) -> bool:
        """
        Initialize a specific plugin
        
        Args:
            name: The plugin name
            
        Returns:
            True if initialization was successful, False otherwise
        """
        plugin = self.get_plugin(name)
        if not plugin:
            logger.error(f"Plugin '{name}' not found")
            return False
        
        try:
            # Register scopes
            scopes = plugin.register_scopes()
            if scopes:
                from app.core.extension_scopes import ExtensionScopeRegistry
                for scope, description in scopes.items():
                    ExtensionScopeRegistry.register_scope(name, scope, description)
            
            plugin.mark_initialized()
            return True
            
        except Exception as e:
            logger.error(f"Failed to initialize plugin '{name}': {e}")
            return False
    
    def initialize_all_plugins(self) -> None:
        """Initialize all registered plugins"""
        for name in self._plugins:
            self.initialize_plugin(name)
        self._initialized = True
        logger.info(f"Initialized {len(self._plugins)} extension plugins")
    
    def register_plugin_routes(self, app: FastAPI) -> None:
        """Register routes from all plugins"""
        for plugin in self._plugins.values():
            if plugin.is_initialized:
                try:
                    plugin.register_routes(app)
                except Exception as e:
                    logger.error(f"Failed to register routes for plugin '{plugin.name}': {e}")
    
    def register_plugin_middleware(self, app: FastAPI) -> None:
        """Register middleware from all plugins"""
        for plugin in self._plugins.values():
            if plugin.is_initialized:
                try:
                    plugin.register_middleware(app)
                except Exception as e:
                    logger.error(f"Failed to register middleware for plugin '{plugin.name}': {e}")
    
    def register_plugin_events(self, app: FastAPI) -> None:
        """Register startup/shutdown events from all plugins"""
        for plugin in self._plugins.values():
            if plugin.is_initialized:
                try:
                    plugin.register_startup_events(app)
                    plugin.register_shutdown_events(app)
                except Exception as e:
                    logger.error(f"Failed to register events for plugin '{plugin.name}': {e}")


# Global plugin manager instance
plugin_manager = ExtensionPluginManager()

