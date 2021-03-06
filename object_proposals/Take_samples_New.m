function [ F, fmaps, row, col ] = Take_samples_New(img, IoU_mat,X, D, opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bb_num = size(X,1);
canonical_w = 64;
canonical_h = 64;

HOG = 0; %1; 

%% histogram feature
binSize = 10;
fmaps = zeros(bb_num, binSize);
for i = 1: bb_num
    I = imcrop(img, X(i,:));
    if ( X(i,1) < 1 ), X(i,1) = 1; end
    if ( X(i,2) < 1 ), X(i,2) = 1; end
    if ( X(i,3) < 1 || X(i,4) < 1 || (X(i,1)+ X(i,3) > size(img,1)) || (X(i,2)+ X(i,4) > size(img,2)) )
        continue;
    end
    
    try
      I2 = imresize(I, [canonical_h canonical_w]);
    catch
        continue;
    end
    

    H = imhist(rgb2gray(I2), binSize);
    H = H/sum(H);
    fmaps(i,:) = H'; 
    %keyboard
end


% if (1 == HOG )
%     %% HOG features
%     binSize = 8;
%     nOrients = 9; % number of orientation bins
%     sz = (uint32(canonical_h/binSize))*(uint32(canonical_w/binSize))*(nOrients*3+5);
%     S = zeros(bb_num, sz);
%     for i =1: bb_num
%         I = single(imcrop(img, X(i,:)))/255;
%         I2 = imresize(I, [canonical_h canonical_w]);
%         H = fhog(I2,binSize,nOrients);
%         fmaps(i,:) = reshape(H, [sz 1]); 
%         %keyboard
%     end
% end
%%%%%%%%%%%%%%%%%


%% sampling params
% sig = opts.sig;
% max_offset = 4*sig+1;
% 
% %% sample
% Nsamples = 100;
% sample_from = ones(size(X,1));
% ii = discretesample(sample_from(:)./sum(sample_from(:)),Nsamples);
% ii = unique(ii);
% Nsamples = length(ii);

%F = fmaps;
IoU_thresh = 0.1; % 10%
[row,col] = find(IoU_mat > IoU_thresh);
Nsample = size(row,1);
%keyboard

F = zeros(Nsample, 2*binSize);

for i=1:Nsample
    F(i,1:binSize) =  fmaps(row(i),:);
    F(i,binSize+1: 2*binSize) =  fmaps(col(i),:);
end

%keyboard
    
% order A and B so that we only have to model half the space (assumes
%%symmetry: p(A,B) = p(B,A))
F = orderAB(F);

%keyboard

end

