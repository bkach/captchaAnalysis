clear all;
close all;
clc;
% pool = parpool(2);

true_labels = importdata('labels.txt');
my_labels = zeros(size(true_labels));

N = 1:size(true_labels, 1);
% N = 42;

% use this variable dependent on how much knowledge you have on the data
% set, i.e. if you are sure, that all the interesting information is in a
% window im(50:end-50, 50:end-50), then use 'offset = 50;'
offset = 70;

tic
for k = N
    im = imread(sprintf('imagedata/train_%04d.png', k));
    my_labels(k, :) = myclassifier(im, offset);
    if (sum(my_labels(k, :)==true_labels(k, :))~=3)
%         imshow(im)
        fprintf(sprintf('in image %i numbers detected are %i %i %i while correct numbers are %i %i %i\n', [k, my_labels(k, :), true_labels(k, :)]));
%         pause
    end
end
toc

fprintf('\n\nAverage precision: \n');
fprintf('%f\n\n', mean(sum(abs(true_labels(N, :) - my_labels(N, :)),2)==0));
% delete(pool);