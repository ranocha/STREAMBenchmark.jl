multithreading() = nthreads() > 1 # defaults to true if threads are available

avxt() = false

macro maybethreads(code)
  esc(:(if $(@__MODULE__).multithreading()
    if $(@__MODULE__).avxt()
        @avxt($code)
    else
        @inbounds @threads($code)
    end
   else
    @inbounds $code
   end))
end

# kernels
function copy(C,A)
    @assert length(C) == length(A)
    @maybethreads for i in eachindex(C,A)
        C[i] = A[i]
    end
    nothing
end

function scale(B,C,s)
    @assert length(C) == length(B)
    @maybethreads for i in eachindex(C)
        B[i] = s * C[i]
    end
    nothing
end

function add(C,A,B)
    @assert length(C) == length(B) == length(A)
    @maybethreads for i in eachindex(C)
        C[i] = A[i] + B[i]
    end
    nothing
end

function triad(A,B,C,s)
    @assert length(C) == length(B) == length(A)
    @maybethreads for i in eachindex(C)
        A[i] = B[i] + s*C[i]
    end
    nothing
end
