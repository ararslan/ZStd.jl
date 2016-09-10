using ZStd
using Base.Test

@testset "helpers" begin
    @test typeof(ZStd.MAX_COMPRESSION) == Int
    @test ZStd.MAX_COMPRESSION > 0

    @test ZStd.check_zstd_error(UInt64(0)) == UInt64(0)
    @test_throws ZStd.ZStdError ZStd.check_zstd_error(typemax(UInt64))

    let
        err = try
            ZStd.check_zstd_error(typemax(UInt64))
        catch ex
            ex
        end
        err_txt = sprint(showerror, err)
        @test startswith(err_txt, "ZStd: Error (generic)")
    end

    @test typeof(ZStd.maxcompressedsize(1)) == Int
    @test ZStd.maxcompressedsize(1) > 0
    @test typeof(ZStd.maxcompressedsize(UInt(1))) == UInt
    @test ZStd.maxcompressedsize(UInt(1)) > UInt(0)

    @test ZStd.ZSTD_VERSION == v"1.0.0"
end
