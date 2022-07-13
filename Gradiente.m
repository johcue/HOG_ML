close all
clear 
clc
C1 = uint8(zeros(3,11,3));
C1(:,:,1)=[255    240   225  210  180   150  105      60   30       15   0;
          255    240   225  210  180   150  105      60   30       15   0;
          255    240   225  210  180   150  105      60   30       15   0];
C1(:,:,2) = C1(:,:,1);
C1(:,:,3) = C1(:,:,1);
figure(1)
imshow(C1, 'initialmagnification','fit')
figure(2)
my_imhist(C1(:,:,1))
figure(3)
imhist(C1(:,:,2))