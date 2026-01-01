"""
Tests for UserRole CRUD API endpoints.
"""

from fastapi.testclient import TestClient


class TestUserRoleEndpoints:
    """Tests for /userrole/ endpoints."""
    
    def test_list_user_roles_structure(self, client: TestClient):
        """Test listing user-roles returns correct structure."""
        response = client.get("/api/family/v1/userrole/?limit=5")
        assert response.status_code == 200
        data = response.json()
        assert "items" in data
        assert "total" in data
        assert "skip" in data
        assert "limit" in data
        assert isinstance(data["items"], list)
    
    def test_list_user_roles_year_validation(self, client: TestClient):
        """Test year filter validation."""
        # Invalid year (out of range)
        response = client.get("/api/family/v1/userrole/?year=100")
        assert response.status_code == 422
    
    def test_get_user_roles_details_structure(self, client: TestClient):
        """Test details endpoint returns correct structure."""
        response = client.get("/api/family/v1/userrole/details?limit=5")
        assert response.status_code == 200
        data = response.json()
        assert "items" in data
        assert "total" in data
    
    def test_get_roles_for_nonexistent_user(self, client: TestClient):
        """Test 404 for non-existent user."""
        response = client.get("/api/family/v1/userrole/user/999999")
        assert response.status_code == 404
    
    def test_get_users_for_nonexistent_role(self, client: TestClient):
        """Test 404 for non-existent role."""
        response = client.get("/api/family/v1/userrole/role/.999.999.")
        assert response.status_code == 404


class TestUserRoleValidation:
    """Tests for user-role input validation and auth."""
    
    def test_create_user_role_requires_auth(self, client: TestClient):
        """Test that creating a user-role requires authentication."""
        response = client.post("/api/family/v1/userrole/", json={
            "user_id": 1,
            "role_id": ".1.5.9.",
            "year": 24
        })
        assert response.status_code == 401
    
    def test_delete_user_role_requires_auth(self, client: TestClient):
        """Test that deleting a user-role requires authentication."""
        response = client.delete("/api/family/v1/userrole/someid")
        assert response.status_code == 401
