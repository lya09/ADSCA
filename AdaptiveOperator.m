function [OffDec,OffMask] = AdaptiveOperator(ParentDec,ParentMask,Fitness,currentGeneration,maxGenerations)

    %% Parameter setting
    [N,D]       = size(ParentDec);
    Parent1Mask = ParentMask(1:N/2,:);
    Parent2Mask = ParentMask(N/2+1:end,:);
    steepness = maxGenerations/10;
    y = 1 ./ (1 + exp((currentGeneration-0.8*maxGenerations)/steepness));
    
    %% Crossover for mask
    OffMask = Parent1Mask;
    if rand < y
       for i = 1 : N/2
            index1 = find(Parent1Mask(i,:)&~Parent2Mask(i,:));
            index2 = find(~Parent1Mask(i,:)&Parent2Mask(i,:));
            index1 = index1(TS(-Fitness(index1)));
            OffMask(i,index1) = 0;
            index2 = index2(TS(Fitness(index2)));
            OffMask(i,index2) = 1;
        end
    end
    
    %% Mutation for mask
     if rand < y
        for i = 1 : N/2
            index3 = find(OffMask(i,:));
            index4 = find(~OffMask(i,:));
            index3 = index3(TS(-Fitness(index3)));
            OffMask(i,index3) = 0;
            index4 = index4(TS(Fitness(index4)));
            OffMask(i,index4) = 1;
        end
    end
  
    %% Crossover and mutation for dec
        OffDec = ones(N/2,D);
   
end

% Binary tournament selection
function index = TS(Fitness)
    if isempty(Fitness)
        index = [];
    else
        index = TournamentSelection(2,1,Fitness);
    end
end