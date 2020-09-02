clear; clc; load('../data/re_los.mat');

%% * Average over batches
reLos = cell(1, nCases);
for iCase = 1 : nCases
    reLos{iCase} = mean(cat(3, reSet{:, iCase}), 3);
end
save('../data/re_los.mat', 'reLos', '-append');

%% * R-E plots
figure('name', 'R-E region for IRS-aided NLoS and LoS channels');
for iCase = 1 : nCases
    plot(reLos{iCase}(1, :) / nSubbands, 1e6 * reLos{iCase}(2, :));
    hold on;
end
hold off;
grid minor;
legend('NLoS', 'LoS');
xlabel('Per-subband rate [bps/Hz]');
ylabel('Average output DC current [\muA]');
ylim([0 inf]);
savefig('../figures/re_los.fig');
