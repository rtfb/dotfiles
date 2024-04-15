#!/bin/bash

rm -rf /tmp/tree-grepper
mkdir -p /tmp/tree-grepper
git clone git@github.com:BrianHicks/tree-grepper.git /tmp/tree-grepper
mkdir -p /tmp/tree-grepper/vendor
cd /tmp/tree-grepper/vendor

# this set is from flake.nix:
git clone git@github.com:elixir-lang/tree-sitter-elixir
git clone git@github.com:elm-tooling/tree-sitter-elm
git clone git@github.com:tree-sitter/tree-sitter-cpp
git clone git@github.com:tree-sitter/tree-sitter-haskell
git clone git@github.com:tree-sitter/tree-sitter-javascript
git clone git@github.com:tree-sitter/tree-sitter-php
git clone git@github.com:tree-sitter/tree-sitter-ruby
git clone git@github.com:tree-sitter/tree-sitter-rust
git clone git@github.com:tree-sitter/tree-sitter-typescript

# this set was added one by one based on build errors:
git clone git@github.com:nix-community/tree-sitter-nix
git clone git@github.com:tree-sitter-grammars/tree-sitter-cuda
git clone git@github.com:tree-sitter-grammars/tree-sitter-markdown
git clone git@github.com:tree-sitter-grammars/tree-sitter-scss
git clone git@github.com:tree-sitter/tree-sitter-c
git clone git@github.com:tree-sitter/tree-sitter-go
git clone git@github.com:tree-sitter/tree-sitter-java
git clone git@github.com:tree-sitter/tree-sitter-python

cd /tmp/tree-grepper
cargo install --path .
