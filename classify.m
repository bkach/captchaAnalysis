function N = classify(img, templateprops)

% templateprops => 3 colums (one for each image) on 2 rows (coords)

% Pad with background (=1)
padded = padarray(img, [1 1], 1); 

% Get size
[h,w] = size(padded);

% get middle section of image
xsec = padded(floor(h/2), :);
ysec = padded(:, floor(w/2));

% Count bands

% 1)
gcmx = graycomatrix(xsec, 'NumLevels', 2);

% Add number of transition 1 -> 0 & 0 -> 1
bx = gcmx(1,2) + gcmx(2,1);

% Same on Y
gcmy = graycomatrix(ysec', 'NumLevels', 2);

% Add number of transition 1 -> 0 & 0 -> 1
by = gcmy(1,2) + gcmy(2,1);

p = cat(1,bx,by);
% classify according to the properties found
for i = 1:3
    % Compute manhattan distance with each point
    d(i) = norm(p-templateprops(:,i),1);
end

[M, x] = min(d); % Get the index of minimum distance with element
N = max(M - 1,0);
