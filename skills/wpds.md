# WordPress Design System (WPDS)

Expert guidance for UI development using the WordPress Design System.

## When to Use

Use when you need to:
- Build UI components for WordPress contexts
- Apply design tokens (colors, spacing, typography)
- Use WordPress component packages
- Implement patterns from the design system

## Applicable Contexts

- Gutenberg editor
- WooCommerce
- WordPress.com
- Jetpack
- Any WordPress admin interface

## Tech Stack

Default to:
- TypeScript
- React
- CSS (or CSS-in-JS where appropriate)

## Component Packages

### @wordpress/components
Primary component library for WordPress admin:

```jsx
import { Button, TextControl, Panel, PanelBody } from '@wordpress/components';

function MyPanel() {
    return (
        <Panel>
            <PanelBody title="Settings">
                <TextControl
                    label="Name"
                    value={name}
                    onChange={setName}
                />
                <Button variant="primary">
                    Save
                </Button>
            </PanelBody>
        </Panel>
    );
}
```

### Common Components

| Component | Use Case |
|-----------|----------|
| `Button` | Actions and links |
| `TextControl` | Single-line input |
| `TextareaControl` | Multi-line input |
| `SelectControl` | Dropdown selection |
| `ToggleControl` | Boolean toggle |
| `Panel/PanelBody` | Collapsible sections |
| `Modal` | Dialog overlays |
| `Notice` | Status messages |
| `Spinner` | Loading indicator |

## Design Tokens

### Colors
```css
/* Primary */
var(--wp-admin-theme-color)
var(--wp-admin-theme-color-darker-10)
var(--wp-admin-theme-color-darker-20)

/* Grays */
var(--wp-components-color-accent)
var(--wp-components-color-background)
```

### Spacing
```css
/* Base unit: 8px */
var(--wp-components-grid-unit-10)  /* 8px */
var(--wp-components-grid-unit-15)  /* 12px */
var(--wp-components-grid-unit-20)  /* 16px */
var(--wp-components-grid-unit-30)  /* 24px */
var(--wp-components-grid-unit-40)  /* 32px */
```

### Typography
```css
var(--wp-components-font-size)
var(--wp-components-font-size-small)
var(--wp-components-font-size-large)
```

## Deliverable Standards

When providing solutions:
1. **Working code snippets** - Demonstrating the implementation
2. **Clear explanation** - What the solution accomplishes
3. **Design reasoning** - Why specific choices were made
4. **Stated boundaries** - What was intentionally excluded

## Scope

Focus exclusively on **UI implementation**. Exclude:
- Data fetching logic
- String localization
- Business logic
- State management architecture

## Target Environment

- WordPress 6.9+
- React 18+
- @wordpress/components package

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wpds)
