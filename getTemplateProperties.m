function P = getTemplateProperties()

% Read templates:
I = {imread('0.png'), imread('1.png'), imread('2.png')};

% Pre-allocate stuff: hopefully it does pre-allocate
bw = cell(3,1);
x  = cell(3,1);
y  = cell(3,1);
glcmx = cell(3,1);
glcmy = cell(3,1);
xb = zeros(1,3);
yb = zeros(1,3);

% {} is the operator for accessing an element in a cell array.
for i = 1:3 % For each template
    % Convert to binary : can probably be pre-processed.
    thr = graythresh(I{i});
    bw{i} = im2bw(I{i}, thr);

    % Pad with background (=1)
    padded{i} = padarray(bw{i}, [1 1], 1);

    % Get the size of images
    [h,w] = size(padded{i});

    % Get the middle section of each template on X & Y.
    x{i}  = padded{i}(floor(h/2),:);
    y{i}  = padded{i}(:, floor(w/2));

    % Count the number of black bands in x{i} and y{i}
    glcmx{i} = graycomatrix(x{i}, 'NumLevels', 2);

    % Add number of transitions 0 -> 1 and 1 -> 0 on X
    xb(i) = glcmx{i}(1,2) + glcmx{i}(2,1);

    glcmy{i} = graycomatrix(y{i}', 'NumLevels', 2);
    % Add number of transitions 0 -> 1 and 1 -> 0 on Y
    yb(i) = glcmy{i}(1,2) + glcmy{i}(2,1);
end

P = cat(1,xb,yb);

end
