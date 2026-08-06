CI & abapLint Suggestions

- Add abapGit-enabled checks using abaplint (https://github.com/abaplint/abaplint)
- Recommended abaplint.json rules (example):
{
  "extends": ["abaplint:recommended"],
  "rules": {
    "max_line_length": { "severity": "warning", "max": 180 }
  }
}

- Consider adding a GitHub Actions workflow to run abaplint on PRs before merges. This repo currently provides Clean ABAP-style examples and should be compatible with abaplint with minimal tweaks.
