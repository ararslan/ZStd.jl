using BinDeps

@BinDeps.setup

zstd = library_dependency("zstd", aliases=["libzstd", "libzstd.1"])

if is_apple()
    using Homebrew
    provides(Homebrew.HB, "zstd", zstd, os=:Darwin)
else
    if isdir(srcdir(zstd))
        rm(srcdir(zstd), recursive=true)
        mkdir(srcdir(zstd))
    end

    if isdir(BinDeps.downloadsdir(zstd))
        rm(BinDeps.downloadsdir(zstd), recursive=true)
        mkdir(BinDeps.downloadsdir(zstd))
    end

    vers = v"1.0.0"

    provides(Sources, URI("https://github.com/facebook/zstd/archive/v$vers.tar.gz"), zstd,
             unpacked_dir="zstd-$vers")

    provides(BuildProcess, (@build_steps begin
        GetSources(zstd)
        @build_steps begin
            ChangeDirectory(joinpath(srcdir(zstd), "openspecfun-$vers"))
            FileRule(joinpath(libdir(zstd), "libopenspecfun." * BinDeps.shlib_ext), @build_steps begin
                CreateDirectory(libdir(zstd))
                `make install PREFIX=$(BinDeps.usrdir(zstd))`
            end)
        end
    end), zstd)
end

@BinDeps.install Dict(:libzstd => :libzstd)
