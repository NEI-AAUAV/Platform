# Frontend Tests

This directory contains unit tests for the frontend business logic, organized by functionality.

## Structure

```
src/__tests__/
├── utils/                    # Utility function tests
│   ├── monthsPassed.test.jsx
│   └── parseJWT.test.jsx
├── services/                 # API service tests
│   ├── refreshToken.test.jsx
│   └── createClient.test.jsx
├── stores/                   # State management tests
│   ├── theme.test.jsx
│   └── authentication.test.jsx
├── test-utils.js            # Shared test utilities
└── README.md               # This file
```

## Test Categories

### 🔧 Utils Tests
- **Date calculations** - `monthsPassed()` function
- **JWT parsing** - Token validation and error handling

### 🌐 Services Tests  
- **Authentication** - Token refresh logic
- **HTTP client** - Request/response interceptors

### 🗃️ Store Tests
- **Theme management** - Light/dark mode switching
- **User authentication** - Login/logout state

## Running Tests

```bash
# Run all tests
yarn test

# Run tests in watch mode
yarn test:ui

# Run tests with coverage
yarn test:coverage
```

## Test Philosophy

These tests focus on **business logic** rather than UI components:

✅ **What we test:**
- Critical business functions
- State management logic
- API integration logic
- Error handling
- Edge cases

❌ **What we don't test:**
- React component rendering
- CSS styling
- Visual appearance
- User interactions

## Adding New Tests

1. **Identify the business logic** you want to test
2. **Choose the appropriate directory** (utils/services/stores)
3. **Create a focused test file** with descriptive name
4. **Use the test-utils.js** helpers when needed
5. **Follow the existing patterns** for consistency
