function [minX, maxX, minY, maxY] = cropImage(im, offset)
    sizeX = size(im, 1);
    sizeY = size(im, 2);
    found = false;
    minX = 1+offset;
    while (~found)
        if (sum(im(minX, :))<sizeY)
            found = true;
        else
            minX = minX + 1;
        end
    end
    found = false;
    maxX = sizeX-offset;
    while (~found)
        if (sum(im(maxX, :))<sizeY)
            found = true;
        else
            maxX = maxX - 1;
        end
    end
    found = false;
    minY = 1+offset;
    while (~found)
        if (sum(im(:, minY))<sizeX)
            found = true;
        else
            minY = minY + 1;
        end
    end
    found = false;
    maxY = sizeY-offset;
    while (~found)
        if (sum(im(:, maxY))<sizeX)
            found = true;
        else
            maxY = maxY - 1;
        end
    end
end