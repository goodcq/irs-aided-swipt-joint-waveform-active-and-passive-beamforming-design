clear; clc; load('../data/re_irs.mat');

%% * Average over batches
reIrs = cell(1, nCases);
for iCase = 1 : nCases
    reIrs{iCase} = mean(cat(3, reSet{:, iCase}), 3);
end
save('../data/re_irs.mat', 'reIrs', '-append');

%% * R-E plots
figure('name', 'R-E region for adaptive, fixed and no IRS');
for iCase = 1 : nCases
    plot(reIrs{iCase}(1, :) / nSubbands, 1e6 * reIrs{iCase}(2, :));
    hold on;
end
hold off;
grid minor;
legend('Adaptive IRS', 'WIT-optimized IRS', 'WPT-optimized IRS', 'No IRS');
xlabel('Per-subband rate [bps/Hz]');
ylabel('Average output DC current [\muA]');
ylim([0 inf]);
savefig('../figures/re_irs.fig');
