clc;
clear;
close all;
x = 0.1:1/22:1;
d = (1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x)/2;


local_max=x(islocalmax(d));
local_min=x(islocalmin(d));

%centrai
tempi = 0;
for i=1:length(local_max)
    c(i)=local_max(i);
end
i_temp=i;

for i=1:length(local_min)
    c(i+i_temp)=local_min(i);
end

num_elem=length(c);

%centru reiksmes
c1 = local_max(1);
c2 = local_max(2);

%spinduliu reiksmes rankinis
%rr=0.17;

r=[0.17 0.15 0.1];

for ii=1:num_elem
    w(ii)=randn(1);
end

b = randn(1);

e=ones(1,20);
res=ones(1,20);

e_total=1;
e_min=0.001;

n=0.01;
iter=1000000;
iter_mem=iter;

while e_total>=e_min & iter>0

            for i=1:length(x)

                %calc errors
                Y=b;
                for ii=1:num_elem
                    y(ii)=exp(-(x(i)-c(ii))^2/(2*r(ii)^2));
                    Y=Y+y(ii)*w(ii);
                end
                e(i) = d(i) - Y;
                
                %update weight s
                for ii=1:num_elem
                    w(ii)=w(ii)+ n * y(ii) * e(i);
                end
                 b = b + n * e(i);
                
            end
            
            %recalc errors
            for i = 1 : length(x)
                res(i)=0;
                for ii=1:2
                    y(ii)=exp(-(x(i)-c(ii))^2/(2*r(ii)^2));
                    res(i)=res(i) + y(ii)*w(ii);
                end
                res(i)=res(i)+b; 
                e(i) = d(i) - res(i);
                
            end

            e_max= max(abs(e));
            e_avg = mean(e.^2);
            e_total=e_avg;
            iter=iter-1;
end  
fprintf("iterations: %d \nmax err %.6f\navg err %.6f",iter_mem-iter,e_max,e_avg);

plot (x,d, '-ko', x, res, '--r*');