"""
Tests for User CRUD API endpoints.
"""

import pytest
from fastapi.testclient import TestClient


class TestUserEndpoints:
    """Tests for /user/ endpoints."""
    
    def test_list_users_structure(self, client: TestClient):
        """Test listing users returns correct structure."""
        response = client.get("/api/family/v1/user/?limit=5")
        assert response.status_code == 200
        data = response.json()
        assert "items" in data
        assert "total" in data
        assert "skip" in data
        assert "limit" in data
        assert isinstance(data["items"], list)
        assert isinstance(data["total"], int)
    
    def test_list_users_pagination(self, client: TestClient):
        """Test pagination parameters."""
        response = client.get("/api/family/v1/user/?limit=2&skip=2")
        assert response.status_code == 200
        data = response.json()
        assert data["skip"] == 2
        assert data["limit"] == 2
    
    def test_get_user_not_found(self, client: TestClient):
        """Test 404 for non-existent user."""
        response = client.get("/api/family/v1/user/999999")
        assert response.status_code == 404
    
    def test_get_user_children_not_found(self, client: TestClient):
        """Test 404 for children of non-existent user."""
        response = client.get("/api/family/v1/user/999999/children")
        assert response.status_code == 404


class TestUserValidation:
    """Tests for user input validation and auth."""
    
    def test_create_user_requires_auth(self, client: TestClient):
        """Test that creating a user requires authentication."""
        response = client.post("/api/family/v1/user/", json={
            "name": "Test User",
            "sex": "M",
            "start_year": 24
        })
        assert response.status_code == 401
    
    def test_update_user_requires_auth(self, client: TestClient):
        """Test that updating a user requires authentication."""
        response = client.put("/api/family/v1/user/1", json={
            "name": "Updated Name"
        })
        assert response.status_code == 401
    
    def test_delete_user_requires_auth(self, client: TestClient):
        """Test that deleting a user requires authentication."""
        response = client.delete("/api/family/v1/user/1")
        assert response.status_code == 401
