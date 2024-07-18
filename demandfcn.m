function currentdemand=demandfcn(time)

%This function takes the current time in hours and gives you the current demand in gpm

    pattern=[2240 2975 4130 3885 3675 3815 4235 2975];
    currentdemand=zeros(1,length(time));
    for t=1:length(time)
        moment=mod(time(t),24);
        currentdemand(t)=pattern(floor(moment/3)+1);
    end
end
