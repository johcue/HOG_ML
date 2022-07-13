function im = HOG_GRAD(hist, hog_bins)

%Construmios las matrices para cada gradiente
bim1 = zeros(hog_bins, hog_bins);%Creamos una matriz de 9x9
bim1(:,round(hog_bins/2):round(hog_bins/2)+1) = 1;%En el centro de esta, almacenamos 1s para despues moverlos atravez de la matriz
bim = zeros([size(bim1) 9]);%Creamos 9 bins de 9x9

%Empezamos a adjuntar los 1s
bim(:,:,1) = bim1;%Lo hacemos por fuera del ciclo porque es desde acá que empezamos a rotar los gradientes
for i = 2:9
    bim(:,:,i) = imrotate(bim1, -(i-1)*9, 'crop');%Rotamos babyyyyyy
end

%Creamos las imagenes de los histogramas positivos añadiendo los gradientes
s = size(hist);    
hist(hist < 0) = 0;    
im = zeros(hog_bins*s(1), hog_bins*s(2));
for i = 1:s(1)
    ii = (i-1)*hog_bins+1:i*hog_bins;
  for j = 1:s(2)
      jj = (j-1)*hog_bins+1:j*hog_bins;          
    for k = 1:9
        im(ii,jj) = im(ii,jj) + bim(:,:,k) * hist(i,j,k);
    end
  end
end
