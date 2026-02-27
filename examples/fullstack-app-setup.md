# Example: Setting Up a Fullstack App with Neural Claude Code

This guide shows how to use the Neural Claude Code plugin to set up and develop a fullstack application with a React frontend and Node.js API.

## Scenario

You're building a task management app with:
- **Frontend**: React + TypeScript + Vite
- **API**: Node.js + Express + PostgreSQL
- **Auth**: JWT-based authentication

## Step 1: Create Project Structure

Start Claude Code in your projects directory:

```bash
mkdir task-manager && cd task-manager
claude
```

### Initialize the Plugin

```
> setup claude
```

Claude creates the `.claude/` structure for your project.

### Ask Claude to Scaffold

```
> Create a monorepo structure for a fullstack app with:
> - apps/web (React + Vite + TypeScript)
> - apps/api (Node.js + Express + TypeScript)
> - packages/shared (shared types)
> Use pnpm workspaces
```

Claude will:
1. Create the directory structure
2. Set up `pnpm-workspace.yaml`
3. Initialize each package with `package.json`
4. Configure TypeScript for each app

## Step 2: Use Output Styles for Different Tasks

### Planning with YAML Style

When planning architecture, use YAML for structured output:

```
> /output-style yaml
> Design the database schema for a task management app with users, projects, and tasks
```

Output:
```yaml
task: "Database schema design"
status: "completed"

schema:
  users:
    columns:
      - name: id
        type: uuid
        primary: true
      - name: email
        type: varchar(255)
        unique: true
      - name: password_hash
        type: varchar(255)
      - name: created_at
        type: timestamp
    indexes:
      - columns: [email]
        unique: true

  projects:
    columns:
      - name: id
        type: uuid
        primary: true
      - name: name
        type: varchar(255)
      - name: owner_id
        type: uuid
        references: users.id
    ...
```

### Coding with Concise Style

When writing code, switch to concise for less verbose output:

```
> /output-style concise
> Create the User model in apps/api/src/models/user.ts
```

### Documentation with Default Style

For explanations and docs:

```
> /output-style default
> Explain how the authentication flow works
```

### Review with TTS Style

Enable TTS when you want audio summaries:

```
> /output-style tts
> Review the API routes for security issues
```

At the end, you'll hear a spoken summary of findings.

## Step 3: Use Multi-AI for Architecture Decisions

For critical decisions, get input from multiple AIs:

```
> /ai-collab Should we use REST or GraphQL for this task management API? Consider:
> - Team has REST experience
> - Need real-time updates for task changes
> - Mobile app planned for future
```

The `multi-ai` agent queries Claude and Codex, then synthesizes:

```
## Consensus Analysis

### Claude (Architecture Focus):
REST with WebSocket for real-time. Simpler for team, clear resource boundaries.

### Codex (Implementation Focus):
REST easier to implement. Add Socket.io for real-time. Mobile can use same endpoints.

## Recommendation
REST + WebSocket hybrid. Team productivity > theoretical benefits of GraphQL.
```

## Step 4: Track Session State

The plugin tracks your session in `.claude/data/current-session.json`:

```json
{
  "session_id": "abc123",
  "agent_name": "Kairosknight",
  "project": "task-manager",
  "output_style": "yaml",
  "started_at": "2024-12-18T10:00:00Z",
  "prompts": [
    "setup claude",
    "Create a monorepo structure...",
    "Design the database schema...",
    "/output-style concise",
    "Create the User model..."
  ]
}
```

The status line shows this context:
```
🟣 opus │ 💡 Create the User model │ Kairosknight │ main +12
```

## Step 5: Build Expertise Over Time

As you work, the plugin learns about your project.

### After Implementing Auth

```
> /meta/improve project
```

Claude updates `.claude/expertise/project.yaml`:

```yaml
domain: "task-manager"
version: "1.0.0"
last_updated: "2024-12-18"

understanding:
  architecture:
    type: "monorepo"
    frontend: "React + Vite"
    backend: "Express + TypeScript"
    database: "PostgreSQL"
    auth: "JWT with refresh tokens"

  patterns:
    - pattern: "API routes in apps/api/src/routes/"
      confidence: 0.9
    - pattern: "Models use TypeORM decorators"
      confidence: 0.85
    - pattern: "Frontend state with Zustand"
      confidence: 0.8

  conventions:
    - "camelCase for variables"
    - "PascalCase for components"
    - "kebab-case for files"
```

### Next Session

When you return:

```
> Where is the user authentication logic?
```

Claude reads the expertise file first and answers accurately:

```
Authentication is in apps/api/src/routes/auth.ts with:
- POST /auth/login - JWT generation
- POST /auth/refresh - Token refresh
- Middleware in apps/api/src/middleware/auth.ts
```

## Step 6: Parallel Development with Worktrees

Working on multiple features simultaneously:

### Create Feature Worktrees

```
> /wt-new feature/user-profiles
> /wt-new feature/task-comments
```

This creates:
```
../worktrees/
├── task-manager-feature-user-profiles/
└── task-manager-feature-task-comments/
```

### Work in Separate Terminals

**Terminal 1 (profiles):**
```bash
cd ../worktrees/task-manager-feature-user-profiles
claude
> Implement user profile page with avatar upload
```

**Terminal 2 (comments):**
```bash
cd ../worktrees/task-manager-feature-task-comments
claude
> Add commenting system to tasks
```

Each instance has its own agent name (e.g., "Nova" and "Cipher"), so you can identify them in status lines.

### Merge When Done

```
> /wt-merge feature/user-profiles
> /wt-merge feature/task-comments
```

## Step 7: Generate UI with GenUI Style

For quick UI prototyping:

```
> /output-style genui
> Create a task card component that shows title, description, assignee, due date, and priority badge
```

Claude generates a complete HTML file with styling and opens it in your browser for preview.

## Workflow Summary

| Phase | Output Style | Tool |
|-------|--------------|------|
| Planning | `yaml` | Clear structured output |
| Architecture | `default` + `/ai-collab` | Multi-AI consensus |
| Coding | `concise` | Minimal overhead |
| Review | `tts` | Hands-free summaries |
| UI Design | `genui` | Visual prototypes |
| Documentation | `default` | Full explanations |

## Commands Used

| Command | Purpose |
|---------|---------|
| `setup claude` | Initialize project |
| `/output-style <name>` | Switch response format |
| `/ai-collab <question>` | Multi-AI collaboration |
| `/meta/improve project` | Update expertise |
| `/wt-new <name>` | Create worktree |
| `/wt-merge <name>` | Merge worktree |
| `/meta/brain` | System status |

## Tips

1. **Start sessions with YAML** - Helps Claude understand complex requirements
2. **Switch to concise for coding** - Faster, less noise
3. **Use TTS for reviews** - Keep coding while listening
4. **Run `/meta/improve` after big changes** - Keeps expertise fresh
5. **Use worktrees for parallel features** - Agent names help track instances
6. **Check `/meta/brain` periodically** - Ensure everything is working

---

This example demonstrates how the Neural Claude Code plugin enhances your development workflow without changing how you code - it just makes Claude smarter about your project over time.
