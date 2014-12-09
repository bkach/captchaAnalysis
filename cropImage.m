function [minX, maxX, minY, maxY] = cropImage(im)
    sizeX = size(im, 1);
    sizeY = size(im, 2);
    find = true;
    minX = 1;
    while (find)
        if (sum(im(minX, :))<sizeY)
            find = false;
        else
            minX = minX + 1;
        end
    end
    find = true;
    maxX = sizeX;
    while (find)
        if (sum(im(maxX, :))<sizeY)
            find = false;
        else
            maxX = maxX - 1;
        end
    end
    find = true;
    minY = 1;
    while (find)
        if (sum(im(:, minY))<sizeX)
            find = false;
        else
            minY = minY + 1;
        end
    end
    find = true;
    maxY = sizeY;
    while (find)
        if (sum(im(:, maxY))<sizeX)
            find = false;
        else
            maxY = maxY - 1;
        end
    end
end