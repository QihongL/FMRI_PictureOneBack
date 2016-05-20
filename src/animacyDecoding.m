%% Do some quick analysis for the manchester MRI data
% a single iteration of logistic regression with lasso or ridge penalty
clear variables; clc; close all;

% specify path information
% point to the directory for the data
DIR.DATA = '/Users/Qihong/Dropbox/github/FMRI_PictureOneBack/data/full/';
% point to the output directory
DIR.OUT = '/Users/Qihong/Dropbox/github/FMRI_PictureOneBack/results/';

% specify parameters
CVCOL = 1;      % use the 1st column of cv idx for now
numCVB = 9;
targetIdx = 1;
options.nlambda = 50;
options.alpha = 1;

% load metadata
load(strcat(DIR.DATA, 'metadata.mat'))
numSubjs = length(metadata);

% get filenames for all subjects
allFileNames = getFileNames(DIR.DATA);

%% analysis

% loop over all subjects
% for s = 1 : numSubjs
s = 1;

% get X and y
load(strcat(DIR.DATA, allFileNames{s}))
y = metadata(s).targets(targetIdx).target;
cvidx = metadata(s).cvind(:,CVCOL);


% loop over all cv blocks
cv = 1;
for cv = 1 : numCVB

% choose a cv index
testIdx = cvidx == cv;
% hold out the test set
X_train = X(~testIdx,:);
X_test = X(testIdx,:);
y_train = y(~testIdx);
y_test = y(testIdx);

% fit the model
cvfit = cvglmnet(X_train, y_train, 'binomial', 'class', options);

yhat = myStepFunction(cvglmnetPredict(cvfit, X_test, cvfit.lambda_min));
accuracy(cv) = sum(yhat == y_test) / length(y_test);

% training accuracy
sum(myStepFunction(cvglmnetPredict(cvfit, X_train, cvfit.lambda_min)) == y_train)/length(y_train)

end
accuracy



% %% save the data
% saveFileName = sprintf(strcat('results.mat'));
% % save(strcat(DIR.OUT,saveFileName), 'results')
