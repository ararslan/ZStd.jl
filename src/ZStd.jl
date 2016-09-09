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
    iserr = Bool(ccall((:ZSTD_isError, :libzstd), Cuint, (Csize_t, ), code))
    if iserr
        msg = unsafe_string(ccall((:ZSTD_getErrorName, :libzstd), Ptr{Cchar}, (Csize_t, ), code))
        throw(ZStdError(msg))
    end
    return code # input is not an error
end


"""
    ZStd.MAX_COMPRESSION

An integer representing the maximum compression level available.
"""
const MAX_COMPRESSION = Int(ccall((:ZSTD_maxCLevel, :libzstd), Cint, ()))


end # module
