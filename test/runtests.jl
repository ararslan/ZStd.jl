using ZStd
using Base.Test

@testset "helpers" begin
    @test typeof(ZStd.MAX_COMPRESSION) == Int
    @test ZStd.MAX_COMPRESSION > 0

    @test ZStd.check_zstd_error(UInt64(0)) == UInt64(0)
    @test_throws ZStd.ZStdError ZStd.check_zstd_error(typemax(UInt64))
end
