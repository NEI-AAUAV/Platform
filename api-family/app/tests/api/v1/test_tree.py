"""
Tests for Tree API endpoint.
"""

from fastapi.testclient import TestClient


class TestTreeEndpoints:
    """Tests for /tree/ endpoints."""
    
    def test_get_full_tree_structure(self, client: TestClient):
        """Test that tree endpoint returns correct structure."""
        response = client.get("/api/family/v1/tree/")
        assert response.status_code == 200
        data = response.json()
        assert "roots" in data
        assert "total_users" in data
        assert isinstance(data["roots"], list)
        assert isinstance(data["total_users"], int)
        assert data["total_users"] >= 0  # Can be 0 for empty DB
    
    def test_get_tree_with_depth_0(self, client: TestClient):
        """Test tree with depth=0 parameter."""
        response = client.get("/api/family/v1/tree/?depth=0")
        assert response.status_code == 200
        data = response.json()
        assert "roots" in data
        # If there are roots, they should have empty children
        for root in data.get("roots", []):
            assert root.get("children", []) == []
    
    def test_get_tree_with_depth_1(self, client: TestClient):
        """Test tree with depth=1 works."""
        response = client.get("/api/family/v1/tree/?depth=1")
        assert response.status_code == 200
        data = response.json()
        assert "roots" in data
    
    def test_get_subtree_nonexistent_user(self, client: TestClient):
        """Test 404 when root_id doesn't exist."""
        response = client.get("/api/family/v1/tree/?root_id=999999")
        assert response.status_code == 404
    
    def test_depth_validation_negative(self, client: TestClient):
        """Test negative depth should fail."""
        response = client.get("/api/family/v1/tree/?depth=-1")
        assert response.status_code == 422
    
    def test_depth_validation_too_large(self, client: TestClient):
        """Test too large depth should fail."""
        response = client.get("/api/family/v1/tree/?depth=100")
        assert response.status_code == 422
