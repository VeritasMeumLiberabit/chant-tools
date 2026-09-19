(lang dune 3.24)

(name chant-tools)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Jonathan Lowe <me@jonathanlowe.dev>")

(maintainers "Jonathan Lowe <me@jonathanlowe.dev>")

(license GPL-3.0-only)

(documentation https://url/to/documentation)

(using menhir 3.0)

(package
 (name chant-tools)
 (synopsis "A short synopsis")
 (description "A longer description")
 (version 0.0.1)
 (depends
   (ocaml (="5.5.1"))
   (menhir (="20260209"))
   (sedlex (="3.7"))
   (cmdliner (="2.1.1"))
   (alcotest :with-test)
   (grace (="0.4.1")))
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
