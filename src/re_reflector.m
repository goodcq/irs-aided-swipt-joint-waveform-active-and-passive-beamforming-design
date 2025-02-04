clear; clc; setup; config_re_reflector;

%% ! R-E region vs number of IRS elements
reSample = cell(nChannels, length(Variable.nReflectors));
reSolution = cell(nChannels, length(Variable.nReflectors));

for iChannel = 1 : nChannels
    for iReflector = 1 : length(Variable.nReflectors)
        % * Get number of reflectors and define spatial correlation
        nReflectors = Variable.nReflectors(iReflector);
        corIrs = eye(nReflectors);

        % * Generate tap gains and delays
        [directTapGain, directTapDelay] = tap_tgn(corTx, corRx, 'nlos');
        [incidentTapGain, incidentTapDelay] = tap_tgn(corTx, corIrs, 'nlos');
        [reflectiveTapGain, reflectiveTapDelay] = tap_tgn(corIrs, corRx, 'nlos');

        % * Construct channels
        [directChannel] = channel_response(directTapGain, directTapDelay, directDistance, rxGain, subbandFrequency, fadingMode);
        [incidentChannel] = channel_response(incidentTapGain, incidentTapDelay, incidentDistance, irsGain, subbandFrequency, fadingMode);
        [reflectiveChannel] = channel_response(reflectiveTapGain, reflectiveTapDelay, reflectiveDistance, rxGain, subbandFrequency, fadingMode);

        % * Alternating optimization
        [reSample{iChannel, iReflector}, reSolution{iChannel, iReflector}] = re_sample_swipt_gp(alpha, beta2, beta4, directChannel, incidentChannel, reflectiveChannel, txPower, noisePower, nCandidates, nSamples, tolerance);
    end
end

% * Average over channel realizations
reInstance = cell(1, length(Variable.nReflectors));
for iReflector = 1 : length(Variable.nReflectors)
    reInstance{iReflector} = mean(cat(3, reSample{:, iReflector}), 3);
end

% * Save batch data
save(sprintf('data/re_reflector/re_reflector_%d.mat', iBatch));
