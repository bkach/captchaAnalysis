function S = detectNumber(im)
    tol  = 5;
    tol2 = 0.55;
    [~, sizeY] = size(im);
    % EITHER it's a ONE
    if (sum(im(:, end-2))<tol)
        S = 1;
    % OR in {ZERO, TWO}
    else
%         if ~(sum(im(sizeX, :))>tol2*sizeY ...
%             || sum(im(sizeX-1, :))>tol2*sizeY ...
%             || sum(im(sizeX-2, :))>tol2*sizeY ...
%             || sum(im(sizeX-3, :))>tol2*sizeY)
        if ~(sum(sum(im(end-2:end, :), 2)>tol2*sizeY)>0)
            S = 2;
        else
            S = 0;
        end
    end
end