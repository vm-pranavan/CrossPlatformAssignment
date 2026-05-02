# Technical Block Architecture Diagram

```mermaid
graph TD
    subgraph "PRESENTATION LAYER (Flutter)"
        UI[Material 3 UI Components]
        Views[Auth & Home Screens]
    end

    subgraph "BUSINESS LOGIC LAYER (State Management)"
        AuthProv[AuthProvider]
        TaskProv[TaskProvider]
        Models[Task & User Models]
    end

    subgraph "DATA LAYER (Service SDK)"
        ParseSvc[ParseService]
        SDK[Parse Server SDK for Flutter]
    end

    subgraph "CLOUD BACKEND (Back4App)"
        AuthAPI[Authentication Service]
        Database[(MongoDB / Parse Database)]
    end

    %% Flow
    UI --> AuthProv
    UI --> TaskProv
    AuthProv --> Models
    TaskProv --> Models
    Models --> ParseSvc
    ParseSvc --> SDK
    SDK <--> AuthAPI
    SDK <--> Database

    %% Styling
    style UI fill:#f8fafc,stroke:#334155,stroke-width:2px
    style Views fill:#f8fafc,stroke:#334155,stroke-width:2px
    style AuthProv fill:#eff6ff,stroke:#2563eb,stroke-width:2px
    style TaskProv fill:#eff6ff,stroke:#2563eb,stroke-width:2px
    style Models fill:#eff6ff,stroke:#2563eb,stroke-width:2px
    style ParseSvc fill:#f0fdf4,stroke:#16a34a,stroke-width:2px
    style SDK fill:#f0fdf4,stroke:#16a34a,stroke-width:2px
    style AuthAPI fill:#fff1f2,stroke:#e11d48,stroke-width:2px
    style Database fill:#fff1f2,stroke:#e11d48,stroke-width:2px
```

## Layer Breakdown

### 1. Presentation Layer
*   **Purpose**: User interaction and data display.
*   **Tools**: Flutter Material 3, Custom SaaS Widgets.

### 2. Business Logic Layer
*   **Purpose**: State management and business rules.
*   **Tools**: Provider (ChangeNotifier), Data Models.

### 3. Data Layer
*   **Purpose**: Communication with external APIs.
*   **Tools**: Parse Server SDK, ParseService abstraction.

### 4. Cloud Backend
*   **Purpose**: Persistent storage and security.
*   **Tools**: Back4App (Auth, NoSQL Database).
