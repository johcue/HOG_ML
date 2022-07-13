function H = Hog_Histogramas(magnitudes,angulos,numBins)
if nargin==1 %Por defecto que utilice 9
    numBins = 9;
end


% Volvemos el tamaño de las celdas a radianes
Cell_Size = pi / numBins;

min_ang = 0; 

% Aquellos angulos negativos se les suma 180 para quitarles el signo 
angulos(angulos < 0) = angulos(angulos < 0) + pi;

% Como los angulos quedan en la "mitad" de cada celda se tiene que encontrar
% el peso en el histograma
IzqCell_index = round((angulos - min_ang) / Cell_Size); %Aprox el valor 
DerCell_index = IzqCell_index + 1;

% Normalizamos el brillo por cada pixel 
Nom_brillo = ((IzqCell_index + 1.5) * Cell_Size) - min_ang;

rightPortions = angulos - Nom_brillo;
leftPortions = Cell_Size - rightPortions;
rightPortions = rightPortions / Cell_Size;
leftPortions = leftPortions / Cell_Size;

H = zeros(1, numBins);

% Para grupo de pixeles, se debe asignar una celda i hacia ambos lados. A cada uno se le ha de sumer la magnitud del gradiente 
for i = 1:numBins
    %Celda Asignada Izquierda
    pixels = (IzqCell_index == i);
    
    %Suma magnitud del gradiente Izquierda
    H(1, i) = H(1, i) + sum(leftPortions(pixels)' * magnitudes(pixels));
    
    %Celda Asignada Derecha 
    pixels = (DerCell_index == i);
        
    %Suma magnitud del gradiente Derecha
    H(1, i) = H(1, i) + sum(rightPortions(pixels)' * magnitudes(pixels));
end    

end