
Succ = zeros(1,round(max(MFCCc,[],'all')));

for k = 1:round(max(MFCCc,[],'all'))
    for i = 1:i12
        for j = 1:i12
            d = norm(MFCCm(i,:)-MFCCm(j,:));
            MFCCc(i,j) = d;
            if d<k
                Succ(k) = Succ(k) + 1;
            end
        end
    end
end
