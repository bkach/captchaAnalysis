function S = myclassifier(im, offset)
    %% default to zeros as return values
    S = zeros(1, 3);
    
    %% first pre-process image to remove noise
    se = strel('square', 4);
    binary_image = im2bw(im, graythresh(im));
    no_noise     = imclose(binary_image, se);
    
    %% now find a sub-image on which we execute template matching
    [minX, maxX, minY, maxY] = cropImage(no_noise, offset);
    % padding by ones to make sure distance transform gives correct result
    minX = minX - 1;
    maxX = maxX + 1;
    minY = minY - 1;
    maxY = maxY + 1;
    % crop image
    subimage = no_noise(minX:maxX, minY:maxY);
%     subimage = imdilate(subimage, strel('square', 4));
    % update size of image that we work on
    sizeX = size(subimage, 1);
    sizeY = size(subimage, 2);
    
    %% split subimage into separate images for each number
    index = 1;
    inObject = false;
    
    for i = 1:sizeY
        if(sum(subimage(:, i))<sizeX)
            if(~inObject)
                results(index) = i;
                index = index + 1;
                inObject = true;
            end
        else
            if(inObject)
                results(index) = i;
                index = index + 1;
                inObject = false;
            end
        end
    end
    numObjects = floor(length(results) / 2);
    % depending on the number of objects that we found, perform another
    % split or assign digits
    if (numObjects < 3)
        if (numObjects == 2)
            % get width of objects
            widthObj1 = results(2) - results(1);
            widthObj2 = results(4) - results(3);
            % use width of objects to decide which contains two digits
            append = (widthObj1 >= widthObj2);
            objectMin = results(3-2*append);
            objectMax = results(4-2*append);

            % pad object that contains two digits to obtain correct
            % distance transformation result
            twoDigits = subimage(:, objectMin:objectMax);
            
            % now split the object in half
            splitX = floor(size(twoDigits,1)/2);
            
            % assign correct digits
            if append
                firstDigit = twoDigits(:, 1:splitX);
                secondDigit = twoDigits(:, splitX:end);
                thirdDigit = subimage(:,results(3):results(4));
            else
                firstDigit = subimage(:, results(1):results(2));
                secondDigit = twoDigits(:, 1:splitX);
                thirdDigit = twoDigits(:, splitX:end);
            end
        else
            firstDigit = subimage(:,1:floor(sizeX/3));
            secondDigit = subimage(:,floor(sizeX/3):floor(2*sizeX/3));
            thirdDigit = subimage(:,floor(2*sizeX/3):sizeX);
        end
    % OR we're done
    else
        firstDigit  = subimage(:, results(1):results(2));
        secondDigit = subimage(:, results(3):results(4));
        thirdDigit  = subimage(:, results(5):results(6));
    end
    
    %% detect numbers in each image
    % only try to find digits in case we have three images to work on
    if ~(isempty(firstDigit) || isempty(secondDigit) || isempty(thirdDigit))

        % firstly, get rid of unnecessary white space
        [minX, maxX, minY, maxY] = cropImage(firstDigit, 0);
        firstDigit = firstDigit(minX:maxX, minY:maxY);
%         se = strel('square', 2);
%         secondDigit = imclose(secondDigit, se);
        [minX, maxX, minY, maxY] = cropImage(secondDigit, 0);
        secondDigit = secondDigit(minX:maxX, minY:maxY);
        [minX, maxX, minY, maxY] = cropImage(thirdDigit, 0);
        thirdDigit = thirdDigit(minX:maxX, minY:maxY);
%         figure
%         subplot(2, 3, [1, 3])
%         imshow(subimage);
%         subplot(2, 3, 5);
%         imshow(secondDigit)
%         subplot(2, 3, 6);
%         imshow(thirdDigit)
%         subplot(2, 3, 4);
%         imshow(firstDigit)
%         results
        
tempProp = [4 2 2; 4 2 6]; %getTemplateProperties();
S(1) = classify(firstDigit, tempProp);
S(2) = classify(secondDigit, tempProp);
S(3) = classify(thirdDigit, tempProp);

        
        %S(1) = detectNumber(firstDigit);
        %S(2) = detectNumber(secondDigit);
        %S(3) = detectNumber(thirdDigit);
    end