#!/usr/bin/env python3

import numpy
import matplotlib.pyplot as plt
from scipy.signal import detrend
from scipy.stats import zscore

def smoosh_file(file):
    with numpy.load(file) as dat:
        c = 0
        xa = []
        za = []
        data = detrend(dat['moA'])
        win = 10
        t = floor(6.7*win) # TODO: remove magic numbers
        for lag in range(-t,t):
            N = len(dat['cA'])
             # cA is the condition, 1 concentrate, 0 relax
            cA2 = numpy.roll(numpy.transpose(dat['']), lag)
            cix = cA2 == 1
            rix = cA2 == 0
            
            c = c + 1
            C = data[cix]
            R = data[rix]
            
            z = zscore(x, axis = 0, ddof = 1);
            
            za = np.concatenate((za, z), axis=0)
            xa = np.concatenate((xa, lag/5), axis=0)
            
        zALL = np.vstack(zALL, zA)  #np.concatenate((a, b.T), axis=1)       might work better
        sz = sum(zALL)/sqrt(zALL[0].shape)
        
        plt.plot(xa, sz)
        plt.plot(xlim, [0 0], ':r')
        plt.plot({0 0}, ylim, ':r")
        plt.xlabel('lag')
        plt.ylabel('zscore')
    print(zALL[0].shape + condtype + 'sessions\n')
    #save(condtype, 'xA', 'sz');

    plt.plot(xa, sz, ':ro')
    #hold on;
    plt.plot(C.xA, C.sz, ':o');     % top
    plt.plot(xlim, [0 0], ':r');
    plt.plot([0 0], ylim, ':r');
    plt.plot([5 5], ylim, ':k');
    xlabel('seconds');
    ylabel('z score');
    title('plasma expt | expt = red | cntl = blue');
    hold off;
    drawnow;


