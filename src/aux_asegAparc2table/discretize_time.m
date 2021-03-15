function code_visits=discretize_time(time_visits,viscode_set)
for i=1:length(time_visits)
    if(time_visits(i)< 3)
        code_visits(i)=viscode_set(1); %bl
    elseif(time_visits(i)< 9)
        code_visits(i)=viscode_set(4); %m06
    elseif(time_visits(i)< 15)
        code_visits(i)=viscode_set(8); %m12
     elseif(time_visits(i)< 22)
        code_visits(i)=viscode_set(15);%m18
     elseif(time_visits(i)< 26)
        code_visits(i)=viscode_set(16);%m24
     elseif(time_visits(i)< 32)
        code_visits(i)=viscode_set(17);%m30
     elseif(time_visits(i)< 38)
        code_visits(i)=viscode_set(18);%m36
     elseif(time_visits(i)< 44)
        code_visits(i)=viscode_set(19);%m42        
     elseif(time_visits(i)< 48)
        code_visits(i)=viscode_set(20);%m48
    elseif(time_visits(i)< 56)
        code_visits(i)=viscode_set(21);%m54
    elseif(time_visits(i)< 62)
        code_visits(i)=viscode_set(22);%m60
    elseif(time_visits(i)< 68)
        code_visits(i)=viscode_set(23);%m66
    elseif(time_visits(i)< 74)
        code_visits(i)=viscode_set(24);%m72        
    elseif(time_visits(i)< 80)
        code_visits(i)=viscode_set(25);%m78 
    else
        code_visits(i)=-1;
    end
end
end