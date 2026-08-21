# Git tag marking the commit where every function is still a TODO. `just reset` restores
# from here, so it must never be moved onto a commit that contains answers.
# Re-point it with: git tag -f stubs <sha>
STUBS := "stubs"

# Finds the one module directory whose name starts with the given argument, e.g. "emb"
# for embedding/ - so a short, misspelling-free prefix is enough to type.
_find module:
    #!/usr/bin/env bash
    set -euo pipefail
    dir=$(ls -d "{{module}}"*/ 2>/dev/null | head -1 || true)
    if [ -z "$dir" ]; then
        echo "no module matching '{{module}}'. available:" >&2
        ls -d */ | grep -v '^\.' | sed 's|/$||; s|^|  |' >&2
        exit 1
    fi
    echo "${dir%/}"

# List available recipes
default:
    @just --list

# Run one module's tests, e.g. `just test emb`
test module:
    #!/usr/bin/env bash
    set -euo pipefail
    dir=$(just _find {{module}})
    go test ./"$dir"/

# Run everything, the way CI does
ci:
    go vet ./...
    go test -race ./...

# Restore one module's exercise file to its unsolved state, e.g. `just reset emb`.
# Only the file you edit is replaced - tests and READMEs are left alone.
reset module:
    #!/usr/bin/env bash
    set -euo pipefail
    dir=$(just _find {{module}})
    for f in $(git ls-tree --name-only {{STUBS}} "$dir/" | grep -v _test.go | grep '\.go$'); do
        git show {{STUBS}}:"$f" > "$f"
        echo "reset $f"
    done

# Restore the whole repo to the stubs commit - every module, README and test file,
# exactly as it was before any answer was written. Leaves this justfile alone, so the
# reset/solution/diff tooling survives the reset that just used it.
reset-all:
    #!/usr/bin/env bash
    set -euo pipefail
    for f in $(git ls-tree -r --name-only {{STUBS}} | grep -v '^justfile$'); do
        git show {{STUBS}}:"$f" > "$f"
    done
    echo "reset to the stubs commit ({{STUBS}})"

# Show the reference answer for one module, e.g. `just solution emb`.
# Reads the solutions branch without touching your working tree.
solution module:
    #!/usr/bin/env bash
    set -euo pipefail
    dir=$(just _find {{module}})
    if ! git rev-parse --verify -q solutions >/dev/null; then
        echo "no solutions branch yet - see 'just help-solutions'" >&2
        exit 1
    fi
    for f in $(git ls-tree --name-only solutions "$dir/" | grep -v _test.go | grep '\.go$'); do
        git show solutions:"$f"
    done

# Diff your answer against the reference, e.g. `just diff emb`
diff module:
    #!/usr/bin/env bash
    set -euo pipefail
    dir=$(just _find {{module}})
    if ! git rev-parse --verify -q solutions >/dev/null; then
        echo "no solutions branch yet - see 'just help-solutions'" >&2
        exit 1
    fi
    git diff solutions -- "$dir"

# How to record an answer once a module is green
help-solutions:
    @echo "Finish a module on main, leave it uncommitted, then:"
    @echo "  git switch -c solutions      # first time. after that: git switch solutions"
    @echo "  git add <module>/ && git commit -m 'solve <module>'"
    @echo "  git switch main"
    @echo ""
    @echo "Uncommitted work follows you across the switch, so there is nothing to stash."
    @echo "main returns to stubs by itself - you never committed the answer there."
