__precompile__()

module ZStd

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
    include(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
else
    error("ZStd.jl is not properly installed. Please run Pkg.build(\"ZStd\") " *
          "and restart Julia.")
end

end # module
