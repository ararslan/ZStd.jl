__precompile__()

module ZStd

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
    include(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
else
    error("ZStd.jl is not properly installed. Please run Pkg.build(\"ZStd\") " *
          "and restart Julia.")
end


immutable ZStdError <: Exception
    msg::String
end

Base.showerror(io::IO, ex::ZStdError) = print(io, "ZStd: " * ex.msg)


# Determine whether the input represents a zstd error, yes => throw it, no => return it
function check_zstd_error(code::Csize_t)
    iserr = Bool(ccall((:ZSTD_isError, libzstd), Cuint, (Csize_t, ), code))
    if iserr
        msg = unsafe_string(ccall((:ZSTD_getErrorName, libzstd), Ptr{Cchar}, (Csize_t, ), code))
        throw(ZStdError(msg))
    end
    return code # input is not an error
end


"""
    ZStd.MAX_COMPRESSION

An integer representing the maximum compression level available.
"""
const MAX_COMPRESSION = Int(ccall((:ZSTD_maxCLevel, libzstd), Cint, ()))


"""
    maxcompressedsize(srcsize)

Get the maximum compressed size in the worst-case scenario for a given input size.
"""
function maxcompressedsize(srcsize::Csize_t)
    return ccall((:ZSTD_compressBound, libzstd), Csize_t, (Csize_t, ), srcsize)
end

maxcompressedsize(srcsize::Int) = Int(maxcompressedsize(Csize_t(srcsize)))


"""
    ZStd.ZSTD_VERSION

The version of Zstandard in use.
"""
const ZSTD_VERSION = let
    ver = Int(ccall((:ZSTD_versionNumber, libzstd), Cuint, ()))
    str = join(match(r"(\d+)(\d{2})(\d{2})$", string(ver)).captures, ".")
    VersionNumber(str)
end

end # module
