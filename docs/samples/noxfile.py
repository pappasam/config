"""Configure nox."""

import nox

NOX_SESSION = nox.session(python=False)


@NOX_SESSION
def fix(session: nox.Session):
    """Fix files inplace."""
    session.run("ruff", "format", "-s", ".")
    session.run("ruff", "check", "-se", "--fix", ".")


@NOX_SESSION
def lint(session: nox.Session):
    """Check file formatting that only have to do with formatting."""
    session.run("ruff", "format", "--check", ".")
    session.run("ruff", "check", ".")


@NOX_SESSION
def typecheck(session: nox.Session):
    """Check types with static type checker."""
    session.run("mypy", "kepler_license_checker")


@NOX_SESSION
def unittests(session: nox.Session):
    """Run unittests."""
    session.run("pytest", "tests/unit")
