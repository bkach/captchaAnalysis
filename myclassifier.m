function S = myclassifier(im)
    %% first pre-process image to remove noise
    se = strel('square', 4);
    binary_image = im2bw(im, graythresh(im));
    no_noise     = imclose(binary_image, se);
    
    sizeX = size(no_noise, 1);
    sizeY = size(no_noise, 2);
    
    %% now find a sub-image on which we execute template matching
    [minX, maxX, minY, maxY] = cropImage(no_noise);
    
    % padding by ones to make sure distance transform gives correct result
    minX = minX - 1;
    maxX = maxX + 1;
    minY = minY - 1;
    maxY = maxY + 1;
    
    % crop image
    subimage = no_noise(minX:maxX, minY:maxY);
    % update size of image that we work on
    sizeX = size(subimage, 1);
    sizeY = size(subimage, 2);
    % image 1
%     imwrite(subimage(1:end-4, 1:28), './template/default_template-2.png');
%     imwrite(subimage(2:end-5, 30:54), './template/default_template-0.png');
    % image 2
%     imwrite(subimage(5:end-1, 35:49), './template/default_template-1.png');

%% split subimage into separate images for each number
    
    % Find boundaries
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
    numObjects = length(results) / 2;
    results
    
     if (numObjects < 3)
         if(numObjects == 2)
             widthObj1 = results(2) - results(1);
             widthObj2 = results(4) - results(3);
             
             if(widthObj1 >= widthObj2)
                 objectMin = results(1);
                 objectMax = results(2);
                 append = true;
             else
                 objectMin = results(3);
                 objectMax = results(4);
                 append = false;
             end
             
             % Create sub-image
             twoDigits  = subimage(:, objectMin:objectMax);
             twoDigits = padarray(twoDigits, [1 1], 1, 'both');
             
             % Distance transform to find the center of the digit
             D = bwdist(twoDigits);

             % Find maximum indices
             [M, x] = max(max(D));
             
             leftDigit = twoDigits(:, objectMin:x);
             rightDigit = twoDigits(:,x:objectMax);
             
             if(append)
                firstDigit = leftDigit;
                secondDigit = rightDigit;
                thirdDigit = subimage(:,results(3):results(4));
             else
                firstDigit = subimage(:, results(1):results(2));
                secondDigit = leftDigit;
                thirdDigit = rightDigit;
             end
             
         end
     else
         firstDigit  = subimage(:, results(1):results(2));
         secondDigit = subimage(:, results(3):results(4));
         thirdDigit  = subimage(:, results(5):results(6));
     end
     
     firstDigit = imclose(firstDigit,strel('square',4));
     secondDigit = imclose(secondDigit,strel('square',4));
     thirdDigit = imclose(thirdDigit,strel('square',4));
     
         figure,
    subplot(2,3,[1,3])
    imshow(subimage);
    subplot(2,3,4)
    imshow(firstDigit);
    subplot(2,3,5)
    imshow(secondDigit);
    subplot(2,3,6)
    imshow(thirdDigit);
     
     [minX, maxX, minY, maxY] = cropImage(firstDigit);
     firstDigit  = firstDigit(minX:maxX,minY:maxY);
     [minX, maxX, minY, maxY] = cropImage(secondDigit);
     secondDigit = secondDigit(minX:maxX,minY:maxY);
     [minX, maxX, minY, maxY] = cropImage(thirdDigit);
     thirdDigit  = thirdDigit(minX:maxX,minY:maxY);
%      
%      se = strel('square', 4);
%     binary_image = im2bw(im, graythresh(im));
%     no_noise     = imclose(binary_image, se);
    
    %% perform template matching on each sub-image

    S(1) = classify(firstDigit,getTemplateProperties());
    S(2) = classify(secondDigit,getTemplateProperties());
    S(3) = classify(thirdDigit,getTemplateProperties());
    
    
%     figure,
%     subplot(2,3,[1,3])
%     imshow(subimage);
%     subplot(2,3,4)
%     imshow(firstDigit);
%     subplot(2,3,5)
%     imshow(secondDigit);
%     subplot(2,3,6)
%     imshow(thirdDigit);
    
    