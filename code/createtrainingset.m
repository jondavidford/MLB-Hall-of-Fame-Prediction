function training_set = createtrainingset(all_careers, time_players)

%{
This is the function used to create our training set in the way we want it.
The first argument, all_careers, is a matrix (created from a csv file
obtained from www.fangraphs.com with desired statistics) of all career
statlines of major league players in history with the only restriction that
they have a qualified number of plate appearances.

The second argument is a matrix (created from a fangraphs csv file) of players who played between certain years. This can be
obtained from www.fangraphs.com as well, by placing restrictions on the
same page used to obtain our all-careers file, and then by altering the
"multiple seasons" dropdown boxes to reflect our season limits.

This function will take the all_careers matrix and recreate a smaller
version of it, by eliminating every player not included in time_players. In
this way, the newly created matrix will contain the career statistics of
every player who played (and obtained a qualifying number of plate
appearances) for any season we specify in our second matrix (time_players).

For batting_all_careers.csv, the columns represent the following, in order:
1. playerid
2. G
3. PA
4. HR
5. R
6. RBI
7. SB
8. ISO
9. BABIP
10. AVG
11. OBP
12. SLG
13. wOBA
14. wRC+
15. BsR
16. WAR
17. HoF classification (1 if in, 0 if not)

%}

all_careers = csvread(all_careers);
time_players = csvread(time_players);

[numOfCareers, numOfStats] = size(all_careers);

training_set = zeros(numOfCareers, numOfStats+1);
counter = 1;



for i=1:numOfCareers
    player_id = all_careers(i,1);
    
    for j=1:size(time_players, 1)
        if(player_id == time_players(j,1))
            training_set(counter,1:16) = all_careers(i,:);
            training_set(counter, 17) = time_players(j,2);
            counter = counter+1;
        end
    end
end


counter = counter -1;
disp('COUNTER:');
disp(counter);
% Counter now represents how many players are in our training set.

training_set = training_set(1:counter,1:17);


end