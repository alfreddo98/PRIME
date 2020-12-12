function [output] = BPSKMod(bits)
    for i=1:1:length(bits);
        if bits(i) == 0
            output(i) = 1;
        else
            output(i) = -1;
        end
    end
end

