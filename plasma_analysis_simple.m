% simple analysis of plasma ball data

clear;

for ctype = 1 : 2 
    zALL = [];
    if(ctype == 1)
        fin = {'dean1', 'dean2', 'dean3', 'dean4', 'dean5', 'dean6',...
            'dean7', 'dean8', 'dean9', 'dean10', 'dean11', 'dean12'};
        condtype = 'experiment';
    else
        fin = {'cntl1', 'cntl2', 'cntl3', 'cntl4', 'cntl5', 'cntl6',...
            'cntl7', 'cntl8', 'cntl9', 'cntl10', 'cntl11', 'cntl12'};
        condtype = 'control';
    end
    
    for k = 1 : length(fin)
        file = char(fin(k));
        load(file);
        
        c = 0; xA = []; zA = [];
        
        data = detrend(moA);        % moA is the overall mean illumination
        % note: check that detrended residuals are independent of each other!
        % if not, a more complex analysis is required
        
        win = 10;                   % seconds of lag to analyze
        t = round(6.7 * win);       % samples per second * win 
        for lag = -t : t
            N = length(cA);

            cA2 = circshift(cA', lag);  % cA is the condition, 1 concentrate, 0 relax
            cix = cA2 == 1;
            rix = cA2 == 0;

            c = c + 1;
            C = data(cix);
            R = data(rix);
            
            [P,H,STATS] = ranksum(C, R);
            z = STATS.zval;

            zA = [zA z];
            xA = [xA lag/5];
        end

        zALL = [zALL ; zA];
        sz = sum(zALL)/sqrt(size(zALL, 1));

        plot(xA, sz);
        hold on;
        plot(xlim, [0 0], ':r');
        plot([0 0], ylim, ':r');
        xlabel('lag');
        ylabel('zscore');
        hold off;            
        drawnow;
    end
    fprintf('%3d %s sessions\n', size(zALL, 1), condtype);
    save(condtype, 'xA', 'sz');
end

%% plot 
C = load('control');
E = load('experiment');

plot(E.xA, E.sz, ':ro');     % top
hold on;
plot(C.xA, C.sz, ':o');     % top
plot(xlim, [0 0], ':r');
plot([0 0], ylim, ':r');
plot([5 5], ylim, ':k');
xlabel('seconds');
ylabel('z score');
title('plasma expt | expt = red | cntl = blue');
hold off;
drawnow;


