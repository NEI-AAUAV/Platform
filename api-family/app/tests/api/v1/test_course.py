"""
Tests for Course CRUD API endpoints.
"""

from fastapi.testclient import TestClient


class TestCourseEndpoints:
    """Tests for /course/ endpoints."""
    
    def test_list_courses_structure(self, client: TestClient):
        """Test listing courses returns correct structure."""
        response = client.get("/api/family/v1/course/?limit=5")
        assert response.status_code == 200
        data = response.json()
        assert "items" in data
        assert "total" in data
        assert "skip" in data
        assert "limit" in data
        assert isinstance(data["items"], list)
    
    def test_list_courses_with_degree_filter(self, client: TestClient):
        """Test filtering by degree."""
        response = client.get("/api/family/v1/course/?degree=Mestrado")
        assert response.status_code == 200
        data = response.json()
        for item in data.get("items", []):
            assert item["degree"] == "Mestrado"
    
    def test_list_courses_show_only(self, client: TestClient):
        """Test show_only filter."""
        response = client.get("/api/family/v1/course/?show_only=true")
        assert response.status_code == 200
        data = response.json()
        for item in data.get("items", []):
            assert item.get("show") == True
    
    def test_list_courses_empty_filter(self, client: TestClient):
        """Test that invalid degree filter returns empty list."""
        response = client.get("/api/family/v1/course/?degree=InvalidDegree")
        assert response.status_code == 200
        data = response.json()
        assert data["items"] == []
        assert data["total"] == 0
    
    def test_get_course_not_found(self, client: TestClient):
        """Test 404 for non-existent course."""
        response = client.get("/api/family/v1/course/999999")
        assert response.status_code == 404


class TestCourseValidation:
    """Tests for course input validation and auth."""
    
    def test_create_course_requires_auth(self, client: TestClient):
        """Test that creating a course requires authentication."""
        response = client.post("/api/family/v1/course/", json={
            "short": "TEST",
            "name": "Test Course",
            "degree": "Mestrado"
        })
        assert response.status_code == 401
    
    def test_create_course_invalid_degree(self, client: TestClient):
        """Test that invalid degree is rejected."""
        response = client.post("/api/family/v1/course/", json={
            "short": "TEST",
            "name": "Test Course",
            "degree": "InvalidDegree"
        })
        # Should return 422 Unprocessable Entity for invalid enum
        assert response.status_code in [401, 422]  # 401 if auth checked first
    
    def test_update_course_requires_auth(self, client: TestClient):
        """Test that updating a course requires authentication."""
        response = client.put("/api/family/v1/course/1", json={
            "name": "Updated Name"
        })
        assert response.status_code == 401
    
    def test_delete_course_requires_auth(self, client: TestClient):
        """Test that deleting a course requires authentication."""
        response = client.delete("/api/family/v1/course/1")
        assert response.status_code == 401
