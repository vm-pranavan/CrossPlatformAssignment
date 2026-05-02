# Task Manager App Architecture

```mermaid
graph TD
    subgraph "Frontend (Flutter App)"
        UI[User Interface - Material 3]
        Prov[Provider State Management]
        Service[Parse Service Layer]
    end

    subgraph "Cloud Backend (Back4App)"
        Auth[Parse Authentication]
        DB[(MongoDB Database)]
        Server[Parse Server API]
    end

    %% Relationships
    UI <--> Prov
    Prov <--> Service
    Service <--> Server
    Server <--> Auth
    Server <--> DB

    %% Styling
    style UI fill:#6366f1,stroke:#312e81,color:#fff
    style Prov fill:#818cf8,stroke:#312e81,color:#fff
    style Service fill:#a5b4fc,stroke:#312e81,color:#000
    style Auth fill:#f43f5e,stroke:#881337,color:#fff
    style DB fill:#10b981,stroke:#064e3b,color:#fff
    style Server fill:#f59e0b,stroke:#78350f,color:#fff
```

## Description of Components

### 1. User Interface (Flutter)
Built using **Flutter** and **Material 3**, the UI provides a professional dashboard and authentication screens. It is designed with a Slate/Indigo palette for an enterprise SaaS feel.

### 2. State Management (Provider)
Uses the **Provider** pattern to manage application state (Auth status, Task lists). This ensures that UI components update automatically when data changes.

### 3. Parse Service Layer
A dedicated service layer that interacts with the **Parse Server SDK**. It handles the transformation of local data models into Parse Objects and vice versa.

### 4. Back4App Backend
A Backend-as-a-Service (BaaS) that manages:
*   **Authentication**: Secure user login and registration.
*   **Database**: A hosted MongoDB for storing and retrieving tasks in real-time.
*   **Server**: The Parse Server API that acts as the bridge between Flutter and the database.
