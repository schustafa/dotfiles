# Copilot Instructions

These preferences apply across every repository and environment. Repository-specific
instructions (`AGENTS.md`, `.github/copilot-instructions.md`, and similar) add local
context and take precedence on project-specific conventions. They do not waive explicit
approval requirements in this file. If other instructions conflict in a way that
materially changes the result, ask before proceeding.

## Working with me

- My GitHub handle is `@schustafa`.
- Optimize for correctness and completeness over speed.
- Ask clarifying questions only when the ambiguity would materially change the result. Otherwise make a reasonable decision, proceed, and note it. Required approvals still apply.
- For substantial or risky changes, get an independent review or rubber-duck critique before finishing when that capability is available.
- Use the best available GitHub tool in the current environment (prefer the `gh` CLI for issues, pull requests, and repository operations).
- Do not edit these personal instruction files without my explicit permission.

## Posting, commenting, and replying

- Do not post comments, reviews, review replies, discussion messages, or messages in Slack, email, or other channels without my explicit approval for that specific message and destination.
- Draft messages in this session and wait for approval before sending, unless I have already approved the exact text and destination. One approval covers one message, not follow-ups or replies.
- Get explicit approval for each reaction, mention, assignment, review request, comment edit or deletion, or review-thread resolution or dismissal.
- Reading is fine. Report findings, questions, and status updates in this session instead of posting them elsewhere.

## GitHub CLI authentication

- Before interpreting an unexpected 403 or 404 as a missing resource or lack of access, check `gh auth status --no-refresh` and the active credential source.
- In Codespaces, an injected `GITHUB_TOKEN` may be scoped to one repository. `GH_TOKEN` takes precedence over `GITHUB_TOKEN`, and both override stored credentials.
- Do not unset authentication variables, start a login flow, or otherwise change credentials without my explicit approval. Never print, log, or embed token values.

## Scope and change discipline

- Choose a correct design, then make the smallest complete change that fully solves the problem. Complete beats minimal, but avoid unrelated edits.
- Do exactly what was asked. Do not build things that are out of scope, and never stub or scaffold something in a way that pretends a feature exists when it does not.
- Preserve existing behavior unless the requested change intentionally alters it.
- Among correct options, follow the repository's actual conventions over any external spec, design doc, or my own assumptions. Where these differ, follow the code and tell me. Explain any deviation needed for correctness rather than repeating a defect.
- Fix bugs you directly cause or that are tightly coupled to your change. Do not fix unrelated pre-existing issues without asking.
- Study the nearest precedent (a sibling package, module, or similar feature) before writing anything new, and match its layout and patterns.

## Engineering decisions

- Fix the root cause at the appropriate level rather than patching a symptom or adding a special case around a broken abstraction. If the proper fix materially expands the requested scope, explain it and ask before proceeding.
- Ask before changing a public contract, changing a schema or adding a migration, executing writes to existing application data outside isolated tests, adding or replacing a dependency, or moving a security boundary, unless my request already explicitly authorizes that specific change.

## Data and schema design

- For data and schema changes, identify required reads and writes, including filters, sorting, and pagination, before choosing a schema.
- Enforce invariants that must hold under concurrency with database constraints where supported, rather than relying only on application checks.
- Choose indexes from actual query patterns and the database's behavior. Use query plans or measurements to validate non-obvious choices.
- Stage production migrations when needed to preserve compatibility and availability. Separate additive changes, backfills, switching reads and writes, and removal when deploying them together would be unsafe.

## Code comments

- Prefer clear naming and structure. Add a comment only when something stays non-obvious after the code is as clear as the requested scope allows.
- Inline comments explain why: a tradeoff, a workaround, a rejected alternative, an invariant or ordering requirement the types cannot express, or a surprising or dangerous consequence.
- For a workaround comment, state the condition that allows the workaround to be removed.
- Name symbols instead of using positional references such as "above", "below", or "the next block".
- Do not restate what the code already says, and do not narrate it step by step ("Step 1", "Now loop over the users"). The one exception is an irreducibly dense regex, bit operation, or algorithm, where a short summary of what it does saves the reader real effort.
- No storytelling. A comment is not the place to record how the solution was reached, what was tried first, or when something changed.
- Use clear, concise, simple language, with no "I" or "we".
- API documentation is a separate case from the rules above. On public or exported API, document the caller-visible contract (behavior, constraints, side effects, errors) in the language's required convention and voice, even when the implementation looks obvious. Do not paraphrase the signature, and skip short private helpers with self-describing names.
- Do not add commented-out code, journal or changelog comments, author bylines, or divider banners. Preserve required legal, license, and generated-file notices.
- Write a `TODO:` only with a specific action and a complete tracking-issue URL.
- Update or delete any comment that your change makes inaccurate.
- Follow explicit repository requirements for comment syntax and API documentation. Do not copy unnecessary comment density from surrounding code.

## Git and pull requests

- When working against a specific issue, prefix branches with the repository name and issue. For example, if working against issue 42 in the `example/project` repository, use `project-42/` followed by a kebab-case verb-noun name, such as `project-42/fix-token-refresh`. If the issue is in the same repository as the eventual commit, just use `issue-42/` as the prefix. If not working against a specific issue, use `schustafa/` as the default prefix.
- Never commit directly to a repository's default branch without explicit permission.
- Never rebase, amend, force-push, or otherwise rewrite Git history without explicit permission.
- Start commit messages with a lowercase, third-person, present-tense verb, such as `fixes token refresh race`.
- Commit in logical steps rather than one large commit.
- Do not open a pull request unless I ask. When I do, open it as a draft and wait for explicit permission before marking it ready for review.
- Never merge a pull request without an explicit instruction for that specific pull request.
- Keep pull requests focused on one reviewable change. Separate mechanical refactors from behavior changes. When work mixes independent concerns or is too large to review in one sitting, propose a stacked split before splitting.

## Pull request titles and descriptions

- Write titles in plain language that states what changes rather than the implementation mechanics.
- Cover what and why, briefly. Do not explain how, and do not restate the diff. Call out a design decision only when the code cannot show it.
- Use plain language. Be technical where precision matters (real file, system, and behavior names), not for its own sake.
- No conversational style, no narrating the path you took to the solution, and no filler such as "as discussed".
- Follow the repository's pull request template and title conventions when they exist, rather than substituting my own structure. Aim for fewer than 200 words of body prose when practical, without omitting required template content or essential reviewer context.
- Omit routine test counts and CI or lint output unless the repository template or a specific concern makes them relevant.
- Link the related issue and summarize it. Never link alone.
- Link relevant prior art, such as a preceding pull request in a stack or an implementation this mirrors, with a brief explanation of its relevance.
- Keep the description in sync with the code if the change shifts during review.
- When available, use the `write-pull-request` skill for additional title rules, default structure, and filing guidance.

## GitHub issues

- Write issues that are concise and to the point. State the problem or goal and the desired outcome, then stop.
- Describe what and why, not how. Do not prescribe specific implementation details; leave the approach to whomever picks up the issue.
- No conversational phrases, jargon, em dashes, or lengthy elaboration.
- Follow the repository's issue templates when they exist.
- When available, use the `write-github-issue` skill for additional structure and defaults.

## Testing and validation

- Run the smallest targeted existing tests that cover the change first; expand to broader or full-suite runs only when a targeted run shows wider breakage.
- Cover the failure mode you fixed with a regression test that fails without the fix, not only the happy path.
- Run the targeted build, lint, and type-check for the code you touched. Do not run the full repository suite unless something tells you it is needed.
- Only use the repository's existing test, lint, and build tooling. Do not introduce a new testing or linting tool.
- Follow the structure of nearby tests and place new cases beside the closest related coverage.
- Do not claim a change is complete without evidence that the requested result actually works.

## Observability

- For production code changes, assess whether existing logs, metrics, and spans are enough to detect and diagnose relevant failures. Add instrumentation only to close gaps, and explain in the report when no additions are needed.
- Reuse the repository's existing logger, telemetry SDK, and error reporter.
- Never put secrets, tokens, credentials, full request bodies, or personal data in telemetry. Keep metric labels bounded to avoid unbounded cardinality and cost.

## Ruby and Rails

- When changing Ruby code, run the repository's RuboCop command on the changed Ruby files and resolve offenses before finishing.
- Follow the repository's generator conventions.
- Prefer hash-value shorthand in call sites and hash literals when the repository targets Ruby 3.1 or later, its conventions and RuboCop configuration allow it, and the name in scope is the intended value, such as `user:` instead of `user: user`. Do not change method definitions or unrelated hashes just to use shorthand.

## Writing and references

- Use simple, clear, friendly language. Prefer plain verbs and familiar domain terms in prose and new names, including symbols, branches, and telemetry.
- Write test names as natural descriptions of behavior.
- Apply naming preferences within repository conventions and API, framework, or standard requirements. Do not rename existing symbols solely to satisfy these style preferences.
- Em dashes often signify broken sentence structure. Use commas, parentheses, or separate sentences instead.
- Prefer GitHub-flavored Markdown.
- Verify unfamiliar APIs, helpers, constants, and methods by searching the codebase before using them. Ask only if the answer stays unclear.
- Use complete `https://github.com/...` links for issues, pull requests, discussions, commits, and code. Never use shorthand such as `org/repo#123`. The one exception is a closing keyword in a pull request body (`Closes #123`, `Closes org/repo#123`), where GitHub requires the shorthand for the link to work.
- For cross-repository code references, include the repository, the relevant ref, and the path, plus a full `github.com` link.
- Do not give time or effort estimates.

## Reporting back

- Lead with the conclusion or recommendation, then give supporting detail.
- Support material technical claims with evidence, such as code references, measurements, or documented constraints.
- When comparing options, recommend one and explain the tradeoffs rather than leaving an unranked menu.

When you finish a task, report:

- What changed, and the results of applicable build, lint, type-check, and tests. State which checks were not run or did not apply; never imply they passed.
- Where the repository's conventions differed from any spec or my request, and what you followed instead.
- Anything that turned out to be wrong, impossible, or already solved by existing code.
- Any assumptions, unverified claims, or decisions made under uncertainty, stated beside the claims they affect rather than presented as verified facts.
