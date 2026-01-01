"""
Tests for Role CRUD API endpoints.
"""

from fastapi.testclient import TestClient


class TestRoleEndpoints:
    """Tests for /role/ endpoints."""
    
    def test_list_roles_structure(self, client: TestClient):
        """Test listing roles returns correct structure."""
        response = client.get("/api/family/v1/role/?limit=5")
        assert response.status_code == 200
        data = response.json()
        assert "items" in data
        assert "total" in data
        assert isinstance(data["items"], list)
    
    def test_get_role_not_found(self, client: TestClient):
        """Test 404 for non-existent role."""
        response = client.get("/api/family/v1/role/.999.999.")
        assert response.status_code == 404
    
    def test_get_role_tree_structure(self, client: TestClient):
        """Test getting the role tree returns a list."""
        response = client.get("/api/family/v1/role/tree")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)


class TestRoleValidation:
    """Tests for role input validation and auth."""
    
    def test_create_role_requires_auth(self, client: TestClient):
        """Test that creating a role requires authentication."""
        response = client.post("/api/family/v1/role/", json={
            "name": "Test Role",
            "parent_id": ".1."
        })
        assert response.status_code == 401
    
    def test_delete_role_requires_auth(self, client: TestClient):
        """Test that deleting a role requires authentication."""
        response = client.delete("/api/family/v1/role/.1.")
        assert response.status_code == 401
