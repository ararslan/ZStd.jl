# ZStd.jl

[![Travis](https://travis-ci.org/ararslan/ZStd.jl.svg?branch=master)](https://travis-ci.org/ararslan/ZStd.jl)
[![Coveralls](https://coveralls.io/repos/github/ararslan/ZStd.jl/badge.svg?branch=master)](https://coveralls.io/github/ararslan/ZStd.jl?branch=master)
[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

A Julia wrapper for the [Zstandard](http://www.zstd.net) library for fast, real-time compression.

Note that while Zstandard itself supports Windows, this package currently does not.
Support may be added in the future, provided I'm able to successfully cross-compile the requisite Windows DLLs.
