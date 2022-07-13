%% Direcctorio HOG
clear 
close all
clc

Path = 'C:\Users\57318\Documents\Aprendizaje_Maquina\Machine_Learning_FISC\Clase\HOG HOG\Photos\Rostros';

FullFile = fullfile(Path, '*.jpg');
Files = dir(FullFile);
cont = 1;
for k = 1:length(Files)
  baseFileName = Files(k).name;
  fullFileName = fullfile(Path, baseFileName);
  I = imread(fullFileName);
  H = Hog_features(I);
  imshow(I);  % Display image.
  drawnow; % Force display to update immediately.
  Hog_Persona(cont,:) = [double(string(fullFileName)) double(H)];
  cont=cont+1;
end

save('HOG_entrenamiento.mat', 'Hog_Persona')
xlswrite('HOG_Entrenamiento.xlsx',Hog_Persona);