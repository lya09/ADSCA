function [Fitness,non_zero,num_temp,same_sparsity] = ScoreUpdate(Mask_dim,non_zero,Fitness,generation,num_temp,same_sparsity,dim,N2)

k = 4;              
freq_threshold_high = 0.7; 
freq_threshold_low = 0.3;   
variable_freq = sum(Mask_dim, 1) / size(Mask_dim, 1); 
if mod(generation, 10) == 0  
    freq_stats = sort(variable_freq);
    freq_threshold_high = freq_stats(ceil(0.7 * length(freq_stats)));
    freq_threshold_low = freq_stats(ceil(0.3 * length(freq_stats)));
end
for i = 1 : size(Mask_dim,1)
    non_zero_temp = find(Mask_dim(i,:));
    non_zero(1,i) = size(non_zero_temp,2);
end
non_zero_num = mode(non_zero(1,:),2);
if generation > 1
    if num_temp == non_zero_num
        same_sparsity = same_sparsity+1;
    else
        same_sparsity = 1;
    end
else
    same_sparsity = 1;
end
num_temp   = non_zero_num;
high_freq_vars = variable_freq >= freq_threshold_high;
low_freq_vars = variable_freq <= freq_threshold_low;
if same_sparsity > k
    for loc = varargin
        Fitness(loc) = Fitness(loc) - ceil(1/N2*Fitness(loc));
    end
end
Fitness(high_freq_vars) = Fitness(high_freq_vars) - ceil(1/N2 * Fitness(high_freq_vars)) ;
Fitness(low_freq_vars) = Fitness(low_freq_vars) + ceil(1/N2 * Fitness(low_freq_vars)) ;
end

