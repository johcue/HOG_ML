function H = Hog_features(Img,hog_CellSize,hog_numVertCells,hog_numHorizCells,hog_numBins)

H = []; %Vector de almacenamiento

P = imresize(rgb2gray(Img),[256 256]);
I = double(P);

%Quiero que mis ventanas sean de un valor especifico:

if nargin==1 %Por defecto que utilice Celdas de 8x8
    hog_CellSize = 8; %Celdas de 8x8
end

% Número de celdas horizontal y vertical
% Como quiero que la celdas sean cuadradas, ambos serán iguales 
if nargin==1 %Por defecto que utilice Steps de 16
    hog_numVertCells = 16; 
end

if nargin==1 %Por defecto que utilice Steps de 16
    hog_numHorizCells = 16;
end

if nargin==1 %Por defecto que utilice 9
    hog_numBins = 9; %9 bloques de Histogramas
end


%Calculo de los gradientes
%Creamos los kernels para para calcular el filtro de la imagen en cada píxel.
fy=[-1 0 1]; %Filtro sobel 
fx=fy';

%APlicamos filtro en cada dirección
Iy=imfilter(I,fy,'replicate');
Ix=imfilter(I,fx,'replicate');

%Hallamos los grandientes en coordenadas polares
magnitudes = sqrt(Ix.^2 + Iy.^2);
angulos = atan2(Iy,Ix);


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

%Nomalizamos
for F = 1:(hog_numVertCells - 1)
     for C = 1:(hog_numHorizCells - 1)
         blockHists = histogramas(F : F + 1, C : C + 1, :);
         magnitud = norm(blockHists(:)) + 0.01;
         Hist_norm = blockHists / magnitud;
         % Adjuntamos los histogramas normalizados al vector features
         H = [H; Hist_norm(:)];
    end
end
H = H';
end