%script per far partire la fase di test
clear all
close all
load Mtest2
load Vtest2
load trainedModelRQGPR
test_noLoad(Mtest2,Vtest2,trainedModelRQGPR)