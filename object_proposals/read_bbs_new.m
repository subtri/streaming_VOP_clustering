function [ I, dt1, dt2 ] = read_bbs_new (images, frame_num, eb_thresh)
%%
% example: 
% all_images = load('test_images1.mat', '-mat');
% images = all_images.value;
%[ I, dt1, dt2 ] = read_bbs (images,1)
%%
%images = load('test_images1.mat', '-mat');

%I = cell2mat(images.value(frame_num));
I = images{frame_num};

eb_name = sprintf('edge_box_new//bbs_new_%d.mat', frame_num);
gop_name = sprintf('GOP//baseline//boxes%d.mat', frame_num);

eb_dt1 = load(eb_name, '-mat');
%dt1 = eb_dt1.bbs(:,1:4);
eb_dt1 = eb_dt1.bbs_new;
indices = find(eb_dt1(:,5) >= eb_thresh );
dt1 = eb_dt1(indices,1:4);
%dt1 = eb_dt1(:,1:4);

%% limit bb number
max_box_num = 150;
if(size(dt1,1) > max_box_num )
    temp_dt1 = dt1(1:max_box_num, :);
    clear dt1;
    dt1 = temp_dt1;
end
clear temp_dt1;
%%

gop_dt2 = load(gop_name, '-mat');
dt2 = gop_dt2.boxes;

%% limit bb number
max_box_num = max_box_num; %100;
if(size(dt2,1) > max_box_num )
    temp_dt2 = dt2(1:max_box_num, :);
    clear dt2;
    dt2 = temp_dt2;
end
clear temp_dt2;

end

