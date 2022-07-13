function Visualizacion_HOG1(Img)
P = imresize(rgb2gray(Img),[256 256]);
I = double(P);

%Calculo de los gradientes
%Creamos los kernels para para calcular el filtro de la imagen en cada píxel.
fy=[-1 0 1];
fx=fy';

%APlicamos filtro en cada dirección
Iy=imfilter(I,fy,'replicate');
Ix=imfilter(I,fx,'replicate');

%Hallamos los grandientes en coordenadas polares
magnitudes = sqrt(Ix.^2 + Iy.^2);
angulos = atan2(Iy,Ix);

hog_CellSize = 8;
hog_numVertCells = 32; %Step
hog_numHorizCells = 32;
hog_numBins = 9; 

histogramas = zeros(hog_numVertCells, hog_numHorizCells, hog_numBins);

% Por cada celda en y
for F = 0:(hog_numVertCells - 1)
    % Seleccionamos los pixeles por cada celda y calculamos el valor de
    % la columna correspondiente al lado derecho en la matriz de la imagen 
    rowOffset = (F * hog_CellSize) + 1;%plus 1 porque las matrices se indexan desde 1

    for C = 0:(hog_numHorizCells - 1)

        % Seleccionamos los pixeles por cada celda y calculamos el valor de
        % la columna correspondiente al lado izquierdo en la matriz de la imagen 
        colOffset = (C * hog_CellSize) + 1; %plus 1 porque las matrices se indexan desde 1

        % Los indices
        rowIndex = rowOffset : (rowOffset + hog_CellSize - 1);
        colIndex = colOffset : (colOffset + hog_CellSize - 1);

        % Angulos y Magnitudes.
        cellAngles = angulos(rowIndex, colIndex); 
        cellMagnitudes = magnitudes(rowIndex, colIndex);

        % Encontramos el histogramas intagramas para cada celda.
        %Volvelos los valores en vectores
        histogramas(F + 1, C + 1, :) = Hog_Histogramas(cellMagnitudes(:), cellAngles(:), hog_numBins);
    end
   
end

scale = max(max(histogramas(:)),max(-histogramas(:)));
pos = HOG_GRAD(histogramas, hog_numBins) * 255/scale;
neg = HOG_GRAD(-histogramas, hog_numBins) * 255/scale;%Porque esta para los positivos

% Ponemos ambas imagenes y graficamos
bin_pad = 0; % Cantidad de valores relleno que se agregaran a cada dimensión
pos = padarray(pos, [bin_pad bin_pad], 128, 'both'); %antes del primer elemento y después del último elemento de matriz a lo largo de cada dimensión.
if min(histogramas(:)) < 0
  neg = padarray(neg, [bin_pad bin_pad], 128, 'both');
  T = pos+neg;
  im = uint8(T);
else
  im = uint8(pos);
end

P1 = imresize(Img,[256 256]);
figure
subplot(1,2,1)
imshow(P1)
subplot(1,2,2)
imshow(im)
imagesc(im); 
colormap gray;
axis equal;
axis off;

end