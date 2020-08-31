#!/usr/bin/env python3

import cv2
import scipy
import numpy
import time
import matplotlib.pyplot as plt
from math import floor

TrialLength = 30
nTrials = 1
nSamples = 100
moA = numpy.empty((nSamples*2))
cA = numpy.empty((nSamples*2))
exptA = numpy.empty((nSamples))
baseA = numpy.empty((nSamples*2))
tA = numpy.empty((nSamples*2))

cam = cv2.VideoCapture(0)

# TODO: get subject name in a nicer way
subject = input("Enter subject name: ")
relax = 1

for epoch in range(nTrials*2):
    if relax == 0:
        relax = 1
        print("Concentrate")
    else:
        #clf;
        relax = 0
        print("Relax")

    t1 = time.time()
    for j in range(nSamples):
        _, o = cam.read()
        time.sleep(.1)
        _, r = cam.read()
        mo = numpy.mean(o)
        moA[epoch*j] = mo
        cA[epoch*j] = relax

        if relax == 1:
            exptA[epoch*j] = mo
            plt.plot(exptA)
            #plot exptA;
            #hold on;
            #plot(xlim, [B B], ':r');
            #hold off;
            #drawnow;
            plt.draw()
            print(f"{j:4d} {B:6.3f}")
        else:
            baseA[epoch*j] = mo
            print(f"{j:4d}")
    t2 = time.time()
    elapsed=floor(t2-t1)
    if relax == 0:
        B = numpy.nanmean(baseA)
        baseA = numpy.empty_like(baseA)
    else:
        exptA = numpy.empty_like(exptA)
numpy.savez_compressed(subject, cA=cA,tA=tA,moA=moA)
cam.release()
cv2.destroyAllWindows()
