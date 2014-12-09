clear all;
close all;
clc;

true_labels = importdata('labels.txt');
my_labels = zeros(size(true_labels));

%N = 1:size(true_labels, 1);
N = 33;

tic
for k = N
    im = imread(sprintf('imagedata/train_%04d.png', k));
    my_labels(k, :) = myclassifier(im);
end
toc

fprintf('\n\nAverage precision: \n');
fprintf('%f\n\n', mean(sum(abs(true_labels - my_labels),2)==0));