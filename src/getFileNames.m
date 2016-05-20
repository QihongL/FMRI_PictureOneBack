function [ allFileNames ] = getFileNames( dataDir )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
allFiles = dir(strcat(dataDir, 's*.mat'));
% allFiles(1:2) = []; 

allFileNames = cell(length(allFiles),1);

for i = 1 : length(allFiles)
%     fprintf('%s\n',allFiles(i).name);
    allFileNames{i} = allFiles(i).name;
end

end

