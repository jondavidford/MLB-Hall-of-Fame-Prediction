function gaussian = creategaussian(class_set, stat_array)

%stat_array is 1xn
%Don't use 1 or 17 in the stat array...plz.

%If you want the graphs to be displayed, make this 1. 
%Else make 0.
wantGraphs = 0;

strings = cell(17, 1);
strings{1,1} = 'Player ID';
strings{2,1} = 'G';
strings{3,1} = 'PA';
strings{4,1} = 'HR';
strings{5,1} = 'R';
strings{6,1} = 'RBI';
strings{7,1} = 'SB';
strings{8,1} = 'ISO';
strings{9,1} = 'BABIP';
strings{10,1} = 'AVG';
strings{11,1} = 'OBP';
strings{12,1} = 'SLG';
strings{13,1} = 'wOBA';
strings{14,1} = 'wRC+';
strings{15,1} = 'BsR';
strings{16,1} = 'WAR';
strings{17,1} = 'HOF Classification';

[numOfPlayers, x] = size(class_set);

numOfStats = length(stat_array(1,:));

a = zeros(numOfPlayers, numOfStats);
% Get specific stats here

for i = 1:numOfStats
    a(:,i) = class_set(:,stat_array(i));
end

sigma = cov(a);

%Calculate the means
mu = zeros(1, numOfStats);
sig = zeros(1, numOfStats);

for i = 1:numOfStats
    mu(1,i) = mean(a(:,i));
    sig(1,i) = std(a(:,i));
end
   
gaussian = gmdistribution(mu, sigma);

if(wantGraphs == 1)
if numOfStats == 2
    figure;
    ezsurf(@(x,y)pdf(gaussian, [x y]), [mu(1,1)-3*sig(1,1) mu(1,1) + 3*sig(1,1)], [mu(1,2)-3*sig(1,2) mu(1,2) + 3*sig(1,2)]);
    
    xlabel(strings{stat_array(1,1)});
    ylabel(strings{stat_array(1,2)});    
    if(class_set(1, 17) == 1)
        %We have a HOF set since we'll be running this with
        %sets of either all HOFs or all scrubs.
        title('Hall of Fame Gaussian Model');
    else
        title('Scrub Gaussian Model');
    end    
end
end
end
    
