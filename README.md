# Rails load_defaults Upgrade Skill for Claude Code

A [Claude Code](https://claude.ai/claude-code) skill that incrementally upgrades `config.load_defaults` in Rails applications by walking through each framework default config one at a time.

## What It Does

This skill automates the process of bringing a Rails app's `load_defaults` configuration up to match its Rails version. It handles:

- **Detection**: Identifies the current `load_defaults` version and Rails version
- **Initializer Generation**: Creates the `new_framework_defaults_X_Y.rb` file from templates
- **Codebase Analysis**: Greps the codebase for each config to recommend the right value
- **Iterative Walkthrough**: Uncomments one config at a time, waits for you to test/commit
- **Consolidation**: Removes the initializer, updates `load_defaults`, and explicitly sets overrides for configs kept at old values

## Installation

**From inside the Claude Code CLI prompt (recommended):**

```
/plugin marketplace add ombulabs/claude-skills
/plugin install rails-load-defaults@ombulabs-ai
```

**From your terminal:**

```bash
claude plugin marketplace add https://github.com/ombulabs/claude-skills.git
claude plugin install rails-load-defaults@ombulabs-ai
```

**Manual install:**

```bash
git clone https://github.com/ombulabs/claude-code_rails-load-defaults-skill.git
cp -r claude-code_rails-load-defaults-skill/rails-load-defaults ~/.claude/skills/
```

Installing to `~/.claude/skills/` makes it available across all your projects.

> [!NOTE]
> This skill works standalone, but it is part of the full Rails upgrade toolkit. You may also want to install [dual-boot](https://github.com/ombulabs/claude-code_dual-boot-skill) and [rails-upgrade](https://github.com/ombulabs/claude-code_rails-upgrade-skill).

## Usage

Once installed, invoke the skill with:

```bash
claude /rails-load-defaults
```

Or start a conversation about load_defaults and Claude will pick it up automatically:

```bash
claude "The app is on Rails 7.2 but load_defaults is at 6.1, let's upgrade"
```

## Supported Versions

| Transition | Config Reference  | Template                                  |
| ---------- | ----------------- | ----------------------------------------- |
| → 5.0      | `rails-load-defaults/configs/5_0.yml` | `rails-load-defaults/templates/new_framework_defaults_5_0.rb` |
| → 5.1      | `rails-load-defaults/configs/5_1.yml` | `rails-load-defaults/templates/new_framework_defaults_5_1.rb` |
| → 5.2      | `rails-load-defaults/configs/5_2.yml` | `rails-load-defaults/templates/new_framework_defaults_5_2.rb` |
| → 6.0      | `rails-load-defaults/configs/6_0.yml` | `rails-load-defaults/templates/new_framework_defaults_6_0.rb` |
| → 6.1      | `rails-load-defaults/configs/6_1.yml` | `rails-load-defaults/templates/new_framework_defaults_6_1.rb` |
| → 7.0      | `rails-load-defaults/configs/7_0.yml` | `rails-load-defaults/templates/new_framework_defaults_7_0.rb` |
| → 7.1      | `rails-load-defaults/configs/7_1.yml` | `rails-load-defaults/templates/new_framework_defaults_7_1.rb` |
| → 7.2      | `rails-load-defaults/configs/7_2.yml` | `rails-load-defaults/templates/new_framework_defaults_7_2.rb` |

## How It Works

### Tiered Config Processing

Each version's configs are organized into tiers:

| Tier   | Risk Level                                | Approach                                            |
| ------ | ----------------------------------------- | --------------------------------------------------- |
| Tier 1 | Very low (test-only, deprecation removal) | Safe to flip with minimal checks                    |
| Tier 2 | Low (needs codebase grep)                 | Claude analyzes the codebase and recommends a value |
| Tier 3 | Medium/High (needs human review)          | Flagged for manual review with detailed guidance    |

Configs are processed in order from safest to riskiest.

### Per-Config Analysis

For each config, the skill provides:

- **What changed**: Old behavior → new behavior
- **Codebase lookup**: Grep patterns to search for relevant code
- **Decision tree**: If X found → use value A, if Y found → use value B
- **Risk level**: How likely this is to break something
- **Old default value**: Used during consolidation if keeping old behavior

### Example Walkthrough

```
Config: action_view.button_to_generates_button_tag
New default: true
Risk: low

Searching codebase...
  ✓ Found 3 uses of button_to in app/views/
  ✓ No CSS/JS targeting input[type=submit]

Recommendation: Safe to use new default (true).
Shall I uncomment this config? [y/n]
```

After you confirm, Claude uncomments the config and waits for you to test and commit before moving to the next one.

### Consolidation

When all configs are done, the skill:

1. Deletes the `new_framework_defaults_X_Y.rb` initializer
2. Updates `config.load_defaults` in `config/application.rb`
3. Adds explicit overrides for any configs kept at old values

```ruby
config.load_defaults 7.0

# Override: kept old behavior because CSS targets input[type=submit]
config.action_view.button_to_generates_button_tag = false
```

## Skill Structure

```
rails-load-defaults-skill/
├── README.md
├── LICENSE
└── rails-load-defaults/                    # Skill directory (name matches SKILL.md name)
    ├── SKILL.md                            # Workflow instructions
    ├── configs/
    │   ├── 5_0.yml                         # Config reference with lookup logic
    │   ├── 5_1.yml
    │   ├── 5_2.yml
    │   ├── 6_0.yml
    │   ├── 6_1.yml
    │   ├── 7_0.yml
    │   ├── 7_1.yml
    │   └── 7_2.yml
    └── templates/
        ├── new_framework_defaults_5_0.rb   # Rails initializer templates
        ├── new_framework_defaults_5_1.rb
        ├── new_framework_defaults_5_2.rb
        ├── new_framework_defaults_6_0.rb
        ├── new_framework_defaults_6_1.rb
        ├── new_framework_defaults_7_0.rb
        ├── new_framework_defaults_7_1.rb
        ├── new_framework_defaults_7_2.rb
        └── cookie_rotator.rb              # SHA1→SHA256 cookie rotation
```

## Adding New Versions

To add support for a new Rails version (e.g., 8.0):

1. Add `rails-load-defaults/templates/new_framework_defaults_8_0.rb` — the initializer from Rails
2. Add `rails-load-defaults/configs/8_0.yml` — config entries with tiers, lookup patterns, and decision trees
3. Update the version references in `rails-load-defaults/SKILL.md`

The workflow logic in `SKILL.md` is version-agnostic, so no other changes are needed.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.

## About FastRuby.io

This skill was created by [FastRuby.io](https://www.fastruby.io), a team specializing in Rails upgrades and technical debt remediation.

Need help with your Rails application? [Contact us for a tech debt assessment!](https://www.fastruby.io/#contactus)
