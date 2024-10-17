#!/bin/bash

git status |
    grep -v "deleted" |
    grep -E "^\s\w+:?" |
    cut -d":" -f2 |
    tr -d "[:blank:]"
