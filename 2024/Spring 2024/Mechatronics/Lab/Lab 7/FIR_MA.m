%Brandon Lim
%Moving Average Filter (Finite Impusle Response)
function Y = FIR_MA(X, N)
    Y(1:N-1)=X(1:N-1); %initializing first terms in filtered data as initial data

    for k=N:length(X)
        Y(k) = sum(X(k-(N-1):k))/N;
    end
end