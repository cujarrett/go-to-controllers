# go-to-controllers

The sequel to [js-to-go](https://github.com/cujarrett/js-to-go): the Go idioms a
`kubebuilder`-scaffolded controller leans on that a JS-comparison track never needed to touch.
No JS lens here - none of this has a JS equivalent worth forcing.

Same loop as js-to-go: each module is a package of stubbed functions and a test file that fails
until you write them. Run the tests, read the failure, write the code, run again.

## Order

| Module | Idea |
|---|---|
| [embedding](./embedding) | struct embedding, method promotion - why `server.Name` and `r.Get(...)` work with no method written for either |
| [generics](./generics) | type parameters, constraints - what `client-go`'s typed clients and listers are built on |
| [deferpanic](./deferpanic) | cleanup that runs no matter how a function ends - finalizers, webhook handlers that must not crash the manager |

Do them in order, one per sitting.

## Running

```sh
go test ./embedding/     # one module
just ci                  # everything
```

A red test naming the thing you have not written yet is the point. Nothing here should be read
without being run.

## How to get the most from it

- **Type the code, do not paste it.** Most of the value is muscle memory.
- **Predict the failure before running.** Being wrong is the signal worth having.
- **`go doc` beats a search engine.** `go doc go-to-controllers/embedding`, offline and exact.

## After this repo

- **Kubernetes controllers, for real** - [The Kubebuilder Book](https://book.kubebuilder.io/)
  CronJob tutorial, then a controller of your own that uses `Owns()`.
- **Concurrency** - goroutines, channels, worker pools. Still deliberately not covered anywhere in
  either repo - it is what Go is famous for and the least of what you need day to day.
