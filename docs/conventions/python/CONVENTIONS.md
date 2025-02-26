# Python Coding Conventions

## Code Formatting

- Use **Ruff** as the primary code formatter and linter
- Configure Ruff to enforce a line length of 88 characters (Black default)
- Enable Ruff's sorting of imports

## Modern Python 3.12+ Features

- Use the union operator (`|`) instead of `Optional` or `Union` (e.g., `str | None`)
- Use `abc` modules instead of `typing` equivalents where possible
- Use built-in collection types for type hints (e.g., `list[str]` instead of `List[str]`)
- Use PEP 695 type parameter syntax for generics
- Use the `@override` decorator when overriding methods
- Leverage f-string syntax enhancements (PEP 701)

## General Style Guidelines

- Follow PEP 8 style guide for all Python code
- Use 4 spaces for indentation (not tabs)
- Use snake_case for functions and variables
- Use CamelCase for class names
- Use UPPERCASE with underscores for constants

## Documentation

- Include docstrings for all public modules, functions, classes, and methods
- Follow PEP 257 for docstring conventions
- Use type hints instead of documenting types in docstrings

## Best Practices

- Follow the Zen of Python (PEP 20)
- Write flat rather than nested code
- Use context managers (with statements) for resource management
- Prefer list/dict comprehensions over map/filter when appropriate
- Use structural pattern matching where it improves readability
