#!/bin/bash
# Reformats the entire tv2hv source tree.
find src/ -type f | rg -e "(.cpp|.h|.hpp)" | xargs -i -- clang-format -i "{}"
