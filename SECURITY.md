# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do NOT** open a public GitHub issue
2. Contact the maintainers directly via email
3. Provide a detailed description of the vulnerability
4. Allow reasonable time for a fix before public disclosure

## Security Considerations

### Data Handling
- This project uses a hotel booking dataset for educational/analysis purposes
- No real guest data should be used without proper consent and anonymization
- Database credentials should never be committed to version control

### Database Security
- Use environment variables for database connection strings
- Implement proper input validation for all SQL queries
- Use parameterized queries to prevent SQL injection
- Follow the principle of least privilege for database users

### Sensitive Data
- `.env` files are excluded via `.gitignore`
- Credentials and API keys must never be committed
- Sample data in SQL files is for demonstration only

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Best Practices

- Keep dependencies updated
- Review code changes for security implications
- Use secure connections for database access
- Implement proper authentication and authorization
- Log security-relevant events
