**Learn the Go a Kubernetes controller actually leans on.**

Small Go modules covering struct embedding, generics, and defer/panic/recover - the idioms every
`kubebuilder`-scaffolded controller uses that a beginner course skips. Each is a handful of
stubbed functions and a test file.

Write the code. Run the test. Read what's wrong. Fix it. Repeat.

No frameworks, no libraries, no dependencies beyond Go itself.

Start at `embedding`. Work down.

## Order

| Module | Idea |
|---|---|
| [embedding](./embedding) | struct embedding, method promotion |
| [generics](./generics) | type parameters, constraints |
| [deferpanic](./deferpanic) | cleanup that runs no matter how a function ends |

## Running

```sh
go test ./embedding/     # one module
just ci                  # everything
```
