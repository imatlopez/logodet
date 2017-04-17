R = [10618  6234 21525 28570 15173 11105 25156 26250 10437 17106;
      7470  7057 16193 15359 10287  7675 12655 15620  7211 11231;
     17499 12585 20080 19087 17700 17101 18583 18572 17235 18086];
C = [-39857.40 -1248.40 -2109.21 -4591.43 -2588.42 -1798.38 -3616.56 -2603.13 -11052.1 -2818.51;
          0.64    4.13      3.18     4.78     3.60    -0.60     2.21     0.88     1.49     5.49;
          1.13    2.36      1.32    -0.03     3.20     0.24     0.74     2.51     2.27     3.24];

M = [1 9 4 7 10 8 5 3 6 2];
R = R(:, M); C = C(:, M);
      
r = (R(:,2:end)-repmat(R(:,1), [1 size(R,2)-1]))./repmat(abs(R(:,1)), [1 size(R,2)-1]);
c = (C(:,2:end)-repmat(C(:,1), [1 size(C,2)-1]))./repmat(abs(C(:,1)), [1 size(C,2)-1]);

figure(1);
set(gcf,'Position', [100, 100, 900, 600])
subplot(2,1,1); bar(100*r); box off;
set(gca,'XTickLabel',{},'FontSize',18,'Color',[1 1 1 0]); ylabel('Detected Features % Change')
set(get(gca,'YLabel'), 'FontSize',20);
set(gca, 'TickDir', 'out')
subplot(2,1,2); bar(c); box off;
set(gca,'XTickLabel',{'Original', 'Zoomed In', 'Full Image'},'FontSize',18,'Color',[1 1 1 0])
xlabel('Source Image / Algorithm Used'); ylabel('{\Delta}log(NFA)/log(NFA_0)')
set(get(gca,'XLabel'), 'FontSize',20);
set(get(gca,'YLabel'), 'FontSize',20);
set(gca, 'TickDir', 'out')

print -dpng -r300 ../ResultsPlot.png
