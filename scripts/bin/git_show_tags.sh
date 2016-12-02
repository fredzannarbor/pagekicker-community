#!/bin/bash
git for-each-ref --format="%(refname:short) %(taggerdate) %(subject) %(body)" refs/tags
