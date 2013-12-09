function [modelErrors] = MLBHallOfFamePrediction(data,numFolds,statArray)
% MLBHallOfFamePrediction
%
% describe that stuff
%
% AUTHORS: Elliott Evans, Jon Ford, Corey McMahon

    % body   
    % num is number of instances
    [numPlayers,numAttributes] = size(data);

    % construct the n sets
    instances=1:numPlayers;
    samples=datasample(instances,numPlayers,'Replace',false);
    
    % size of validation sets
    validationSetSize=floor(numPlayers/numFolds);
    
    % each row of validationSets is one validation set
    % each number in each row represents one player
    validationSets=zeros(numFolds,validationSetSize);
    for i=1:numFolds
        validationSets(i,:)=samples((i*validationSetSize-(validationSetSize-1)):(i*validationSetSize));
    end
    
    trainingSetSize=(numFolds-1)*validationSetSize;
    modelErrors=zeros(1,numFolds);
    baselineErrors=zeros(1,numFolds);
    for i=1:numFolds
        % i corresponds to the current row of validationSets that we will
        % test on. Players in this row are the testingSet
        testingSetRows=validationSets(i,:);
        testingSet=zeros(validationSetSize,numAttributes);
        
        % create the testing set
        currentRow=1;
        for player=testingSetRows
            testingSet(currentRow,:)=data(player,:);
            currentRow=currentRow+1;
        end
        
        trainingSet=zeros(trainingSetSize,numAttributes);
        currentRow=1;
        for j=1:numFolds
            if (j ~= i)
                % then this row is part of the training set
                trainingSetRows=validationSets(j,:);
                for player=trainingSetRows
                    trainingSet(currentRow,:)=data(player,:);
                    currentRow=currentRow+1;
                end
            end
        end
        [HoF, nonHoF] = divideset(trainingSet);
        gaussianHoF = creategaussian(HoF,statArray);          
        gaussianNonHoF = creategaussian(nonHoF,statArray);      
        
        % classify as HoF or not
        numMisclassifications=0;
        numBaselineMisclassifications=0;
        for player=1:validationSetSize
            playerStats=testingSet(player,statArray);
            zHoF=pdf(gaussianHoF,playerStats);
            zNonHoF=pdf(gaussianNonHoF,playerStats);
            if (zHoF > zNonHoF)
                classification = 1;
            else
                classification = 0;
            end
            
            actualClassification=testingSet(player,end);
            if (actualClassification~=classification)
                numMisclassifications=numMisclassifications+1;
            elseif (actualClassification==0)
                numBaselineMisclassifications=numBaselineMisclassifications+1;
            end
            
            if(testingSet(player,end)==1 && classification==1)
                disp('CORRECTLY GOT A HOFer');
            end
            if(testingSet(player,end)==0 && classification==0)
                disp('CORRECTLY GOT A SCRUB');
            end
            if(testingSet(player,end)==1 && classification==0)
                disp('ACCIDENTALLY CALLED A HALL OF FAMER A SCRUB*********');
            end
            if(testingSet(player,end)==0 && classification==1)
                disp('ACCIDENTALLY CALLED A SCRUB A HALL OF FAMER*********');
            end
        end
        modelError=numMisclassifications/validationSetSize;
        baselineError=numBaselineMisclassifications/validationSetSize;
        modelErrors(i)=modelError;
        baselineErrors(i)=baselineError;
    end

end