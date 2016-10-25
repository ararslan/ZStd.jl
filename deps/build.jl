using BinDeps

if is_windows()
    error("The ZStd package does not currently support Windows.")
end

BinDeps.@setup

vers = v"1.1.0"

zstd = library_dependency("zstd", aliases=["libzstd", "libzstd.$(vers.major)", "libzstd.$vers"])

if is_apple()
    using Homebrew
    provides(Homebrew.HB, "zstd", zstd, os=:Darwin)
else
    provides(Sources, URI("https://github.com/facebook/zstd/archive/v$vers.tar.gz"), zstd,
             unpacked_dir="zstd-$vers")

    provides(BuildProcess, (@build_steps begin
        GetSources(zstd)
        @build_steps begin
            ChangeDirectory(joinpath(srcdir(zstd), "zstd-$vers"))
            FileRule(joinpath(libdir(zstd), "libzstd." * BinDeps.shlib_ext), @build_steps begin
                CreateDirectory(libdir(zstd))
                `make install PREFIX=$(BinDeps.usrdir(zstd))`
            end)
        end
    end), zstd)
end

BinDeps.@install Dict(:zstd => :libzstd)
