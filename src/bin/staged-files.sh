#!/bin/bash

git status --porcelain |
    grep -v "^ D" |
    cut -c4-
