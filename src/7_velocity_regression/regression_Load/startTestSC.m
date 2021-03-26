%script per far partire la fase di test
clear all
close all
load matriceTestSC
load VtestSC
load trainedModelExpGPR_SC
test_Load(matriceTestSC,VtestSC,trainedModelExpGPR_SC)
