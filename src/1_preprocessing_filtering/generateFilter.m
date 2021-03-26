function Hd = generateFilter
    
    % All frequency values are in Hz.
    Fs = 2000;  % Sampling Frequency

    Fpass = 50;          % Passband Frequency
    Fstop = 60;          % Stopband Frequency
    Apass = 1;           % Passband Ripple (dB)
    Astop = 80;          % Stopband Attenuation (dB)
    match = 'stopband';  % Band to match exactly

    % Construct an FDESIGN object and call its CHEBY2 method.
    h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
    Hd = design(h, 'cheby2', 'MatchExactly', match);

end