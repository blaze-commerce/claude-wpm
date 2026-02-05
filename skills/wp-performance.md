# WordPress Performance

Expert guidance for WordPress performance investigation and optimization.

## When to Use

Use when you need to:
- Diagnose slow WordPress sites
- Profile and optimize database queries
- Implement caching strategies
- Optimize cron tasks and HTTP calls
- Reduce page load times

## Diagnostic Workflow

### 1. Baseline Metrics

```bash
# Measure response time
curl -w "%{time_total}\n" -o /dev/null -s https://example.com

# With WP-CLI
wp profile stage --url=https://example.com
```

### 2. Health Check

```bash
# Common production issues
wp doctor check

# Checks for:
# - Autoload bloat
# - SAVEQUERIES/WP_DEBUG enabled
# - Caching status
```

### 3. Deep Profiling

```bash
# Profile by stage
wp profile stage --url=https://example.com

# Profile specific hook
wp profile hook init --url=https://example.com

# Profile code evaluation
wp profile eval 'get_posts();' --url=https://example.com
```

## Optimization Categories

### Database Queries

- Use proper indexes on custom tables
- Avoid `meta_query` on large datasets
- Cache expensive queries with transients
- Consider object cache for repeated queries

### Autoloaded Options

```bash
# Check autoload size
wp db query "SELECT SUM(LENGTH(option_value)) FROM wp_options WHERE autoload='yes';"

# Identify large autoloaded options
wp db query "SELECT option_name, LENGTH(option_value) as size FROM wp_options WHERE autoload='yes' ORDER BY size DESC LIMIT 20;"
```

### Object Cache

```bash
# Check if object cache is in use
wp cache type

# Recommended: Redis or Memcached
```

### Remote HTTP Calls

- Cache external API responses
- Use `wp_remote_get()` with timeout
- Consider background processing for slow APIs

### Cron Optimization

- Make tasks idempotent
- Avoid long-running single events
- Consider wp-cron alternatives for high-traffic sites

## WordPress 6.9 Enhancements

- Classic themes: On-demand CSS loading (30-65% reduction)
- Block themes: Zero render-blocking CSS via inlined global styles

## Safety Guidelines

- Compare baseline vs post-optimization in identical environments
- No production changes without explicit approval
- No cache flushes during traffic peaks
- No plugin installation without authorization

## Target Environment

- WordPress 6.9+
- PHP 7.2.24+
- WP-CLI recommended

## Source

Based on [WordPress/agent-skills](https://github.com/WordPress/agent-skills/tree/trunk/skills/wp-performance)
