clear, clc, close all
% load desired input trajectory signal---------
load yd01.in % trajectory for 1 Hz
yd = yd01(1:29999);
SignalFreq = 1; % Hz
SamplingFreq = 500; % Hz
dt = 1/SamplingFreq;
t = dt*[0:length(yd)-1];% time(s)--signal length
figure(1);clf;
subplot(211); plot(t,yd); xlabel('time (s)'); ylabel('y_d')

%======================================================
% system modeling for (Transfer Function) G
%system modeling for (Transfer Function) G
%======================================================
w = load('cm.x'); % load frequency
mag = load('cm.txt'); % load mag in dB
ph = load('cp.txt'); % ph in deg.
wn = find(w>130); % wn = find(w>133);
w = w(1:wn(1));
mag = mag(1:wn(1));
ph = ph(1:wn(1));

figure(2);clf;
subplot(211); semilogx(w,mag,'k'); xlabel('Freq. (Hz)'); ylabel('Mag. (dB)'); hold on
subplot(212); semilogx(w,ph,'k'); xlabel('Freq. (Hz)'); ylabel('Ph. (deg)');hold on

%complex freq response G (Transfer Function)-----
i = sqrt(-1);
for k =1:length(w)
    a = 10^(mag(k)/20)*cos(ph(k)*pi/180);
    b = 10^(mag(k)/20)*sin(ph(k)*pi/180);
    G(k,1) = a+b*i; % the Transfer Function of system
end

% make G even and get G_jq (conjugate of G)------
w = [0;w];
G = [G(1); G]; % Even G
G_jq = conj(G); % The conjugate of the even TF (G)
ome_g = w*2*pi; % get the omega of G_ff and G

% Create your optimal inversion code below -- please follow the process flow described in homework.
%Step 1
%Compute Optimal Inversion of Transfer Function
Q(0<=w & w<130) = 1;
Q(w>130) = 0;
R(0<w & w<130) = 0;
R(w>130) = 1;
Q = Q';
R = R';

%Calculate Optimal Inversion Transfer Function
for i = 1:length(w)
    Gff(i,1) = (G_jq(i)*Q(i))/(R(i) + G_jq(i)*Q(i)*G(i));
end

% Step 2
% Cleaning up Yd for fft
I1 = find(t == 15);
I2 = find(t == 45);
yd = yd(I1:I2);

[Mag, Phase, freq, Yd_FFT] = fft_sample(yd, 500);
figure
plot(freq,Mag)

G_interp = interp1(ome_g, G, freq*2*pi, "linear",0);
Gff_interp = interp1(ome_g, Gff, freq*2*pi, "linear",0);

G_Full = [G_interp,flip(conj(G_interp(1:end-1)))]';
Gff_Full = [Gff_interp,flip(conj(Gff_interp(1:end-1)))]';

Uopt_jw = Gff_Full .* Yd_FFT;
Yopt_jw = G_Full .* Uopt_jw;

uopt = real(ifft(Uopt_jw));
yd_opt = real(ifft(Yopt_jw));

cycIdx1 = find(t==26);
cycIdx2 = find(t==29);

figure
subplot(2,1,1)
hold on
plot(t(cycIdx1:cycIdx2), yd(cycIdx1:cycIdx2), "k")
plot(t(cycIdx1:cycIdx2), yd_opt(cycIdx1:cycIdx2), "--r")
legend("$y_d(t)$", "$y_{opt}(t)$", "Interpreter", "Latex")
xlabel("Time"); ylabel("Respone"); title("Desired and Optimal Trajectory vs Time [1 Hz Signal]")
subplot(2,1,2)
plot(t(cycIdx1:cycIdx2),uopt(cycIdx1:cycIdx2))
xlabel("Time"); ylabel("Input"); title("Optimal Input vs Time [1 Hz Signal]")

%% 5Hz
clear, clc, close all
% load desired input trajectory signal---------
load yd01.in % trajectory for 1 Hz
yd = yd01(1:29999);
SignalFreq = 5; % Hz
SamplingFreq = 500; % Hz
dt = 1/SamplingFreq;
t = dt*[0:length(yd)-1];% time(s)--signal length
yd = interp1(t, yd, t.*SignalFreq, 'linear', 0);
figure(1);clf;
subplot(211); plot(t,yd); xlabel('time (s)'); ylabel('y_d')

tstart = 15/SignalFreq;
tend = 45/SignalFreq;

I1 = find(t==tstart);
I2 = find(t==tend);
t = t(I1:I2);
yd = yd(I1:I2);


%======================================================
% system modeling for (Transfer Function) G
%system modeling for (Transfer Function) G
%======================================================
w = load('cm.x'); % load frequency
mag = load('cm.txt'); % load mag in dB
ph = load('cp.txt'); % ph in deg.
wn = find(w>130); % wn = find(w>133);
w = w(1:wn(1));
mag = mag(1:wn(1));
ph = ph(1:wn(1));

figure(2);clf;
subplot(211); semilogx(w,mag,'k'); xlabel('Freq. (Hz)'); ylabel('Mag. (dB)'); hold on
subplot(212); semilogx(w,ph,'k'); xlabel('Freq. (Hz)'); ylabel('Ph. (deg)');hold on

%complex freq response G (Transfer Function)-----
i = sqrt(-1);
for k =1:length(w)
    a = 10^(mag(k)/20)*cos(ph(k)*pi/180);
    b = 10^(mag(k)/20)*sin(ph(k)*pi/180);
    G(k,1) = a+b*i; % the Transfer Function of system
end

% make G even and get G_jq (conjugate of G)------
w = [0;w];
G = [G(1); G]; % Even G
G_jq = conj(G); % The conjugate of the even TF (G)
ome_g = w*2*pi; % get the omega of G_ff and G

% Create your optimal inversion code below -- please follow the process flow described in homework.
%Step 1
%Compute Optimal Inversion of Transfer Function
Q(0<=w & w<130) = 1;
Q(w>130) = 0;
R(0<w & w<130) = 0;
R(w>130) = 1;
Q = Q';
R = R';

%Calculate Optimal Inversion Transfer Function
for i = 1:length(w)
    Gff(i,1) = (G_jq(i)*Q(i))/(R(i) + G_jq(i)*Q(i)*G(i));
end

% Step 2
% Cleaning up Yd for fft

[Mag, Phase, freq, Yd_FFT] = fft_sample(yd, 500);
figure
plot(freq,Mag)

G_interp = interp1(ome_g, G, freq*2*pi, "linear",0);
Gff_interp = interp1(ome_g, Gff, freq*2*pi, "linear",0);

G_Full = [G_interp,flip(conj(G_interp(1:end-1)))];
Gff_Full = [Gff_interp,flip(conj(Gff_interp(1:end-1)))];

Uopt_jw = Gff_Full .* Yd_FFT;
Yopt_jw = G_Full .* Uopt_jw;

uopt = real(ifft(Uopt_jw));
yd_opt = real(ifft(Yopt_jw));

numSec = 3/SignalFreq;

cycIdx1 = find(t==(tend-numSec));
cycIdx2 = find(t==(tend));

figure
subplot(2,1,1)
hold on
plot(t(cycIdx1:cycIdx2), yd(cycIdx1:cycIdx2), "k")
plot(t(cycIdx1:cycIdx2), yd_opt(cycIdx1:cycIdx2), "--r")
legend("$y_d(t)$", "$y_{opt}(t)$", "Interpreter", "Latex")
xlabel("Time"); ylabel("Respone"); title("Desired and Optimal Trajectory vs Time [5 Hz Signal]")
subplot(2,1,2)
plot(t(cycIdx1:cycIdx2),uopt(cycIdx1:cycIdx2))
xlabel("Time"); ylabel("Input"); title("Optimal Input vs Time [5 Hz Signal]")

%% 10Hz
clear, clc, close all
% load desired input trajectory signal---------
load yd01.in % trajectory for 1 Hz
yd = yd01(1:29999);
SignalFreq = 10; % Hz
SamplingFreq = 500; % Hz
dt = 1/SamplingFreq;
t = dt*[0:length(yd)-1];% time(s)--signal length
yd = interp1(t, yd, t.*SignalFreq, 'linear', 0);
figure(1);clf;
subplot(211); plot(t,yd); xlabel('time (s)'); ylabel('y_d')

tstart = 15/SignalFreq;
tend = 45/SignalFreq;

I1 = find(t==tstart);
I2 = find(t==tend);
t = t(I1:I2);
yd = yd(I1:I2);


%======================================================
% system modeling for (Transfer Function) G
%system modeling for (Transfer Function) G
%======================================================
w = load('cm.x'); % load frequency
mag = load('cm.txt'); % load mag in dB
ph = load('cp.txt'); % ph in deg.
wn = find(w>130); % wn = find(w>133);
w = w(1:wn(1));
mag = mag(1:wn(1));
ph = ph(1:wn(1));

figure(2);clf;
subplot(211); semilogx(w,mag,'k'); xlabel('Freq. (Hz)'); ylabel('Mag. (dB)'); hold on
subplot(212); semilogx(w,ph,'k'); xlabel('Freq. (Hz)'); ylabel('Ph. (deg)');hold on

%complex freq response G (Transfer Function)-----
i = sqrt(-1);
for k =1:length(w)
    a = 10^(mag(k)/20)*cos(ph(k)*pi/180);
    b = 10^(mag(k)/20)*sin(ph(k)*pi/180);
    G(k,1) = a+b*i; % the Transfer Function of system
end

% make G even and get G_jq (conjugate of G)------
w = [0;w];
G = [G(1); G]; % Even G
G_jq = conj(G); % The conjugate of the even TF (G)
ome_g = w*2*pi; % get the omega of G_ff and G

% Create your optimal inversion code below -- please follow the process flow described in homework.
%Step 1
%Compute Optimal Inversion of Transfer Function
Q(0<=w & w<130) = 1;
Q(w>130) = 0;
R(0<w & w<130) = 0;
R(w>130) = 1;
Q = Q';
R = R';

%Calculate Optimal Inversion Transfer Function
for i = 1:length(w)
    Gff(i,1) = (G_jq(i)*Q(i))/(R(i) + G_jq(i)*Q(i)*G(i));
end

% Step 2
% Cleaning up Yd for fft

[Mag, Phase, freq, Yd_FFT] = fft_sample(yd, 500);
figure
plot(freq,Mag)

G_interp = interp1(ome_g, G, freq*2*pi, "linear",0);
Gff_interp = interp1(ome_g, Gff, freq*2*pi, "linear",0);

G_Full = [G_interp,flip(conj(G_interp(1:end-1)))];
Gff_Full = [Gff_interp,flip(conj(Gff_interp(1:end-1)))];

Uopt_jw = Gff_Full .* Yd_FFT;
Yopt_jw = G_Full .* Uopt_jw;

uopt = real(ifft(Uopt_jw));
yd_opt = real(ifft(Yopt_jw));

numSec = 3/SignalFreq;

cycIdx1 = find(t==(tend-numSec));
cycIdx2 = find(t==(tend));

figure
subplot(2,1,1)
hold on
plot(t(cycIdx1:cycIdx2), yd(cycIdx1:cycIdx2), "k")
plot(t(cycIdx1:cycIdx2), yd_opt(cycIdx1:cycIdx2), "--r")
legend("$y_d(t)$", "$y_{opt}(t)$", "Interpreter", "Latex")
xlabel("Time"); ylabel("Respone"); title("Desired and Optimal Trajectory vs Time [10 Hz Signal]")
subplot(2,1,2)
plot(t(cycIdx1:cycIdx2),uopt(cycIdx1:cycIdx2))
xlabel("Time"); ylabel("Input"); title("Optimal Input vs Time [10 Hz Signal]")

%% 18Hz
clear, clc, close all
% load desired input trajectory signal---------
load yd01.in % trajectory for 1 Hz
yd = yd01(1:29999);
SignalFreq = 18; % Hz
SamplingFreq = 500; % Hz
dt = 1/SamplingFreq;
t = dt*[0:length(yd)-1];% time(s)--signal length
yd = interp1(t, yd, t.*SignalFreq, 'linear', 0);
figure(1);clf;
subplot(211); plot(t,yd); xlabel('time (s)'); ylabel('y_d')

tstart = 15/SignalFreq;
tend = 45/SignalFreq;

% [~,I1] = min(abs(t-0.833));
% I2 = find(t==tend);
I  = find(yd);
I1 = I(1) - 1;
I2 = I(end) + 1;
t = t(I1:I2);
yd = yd(I1:I2);


%======================================================
% system modeling for (Transfer Function) G
%system modeling for (Transfer Function) G
%======================================================
w = load('cm.x'); % load frequency
mag = load('cm.txt'); % load mag in dB
ph = load('cp.txt'); % ph in deg.
wn = find(w>130); % wn = find(w>133);
w = w(1:wn(1));
mag = mag(1:wn(1));
ph = ph(1:wn(1));

figure(2);clf;
subplot(211); semilogx(w,mag,'k'); xlabel('Freq. (Hz)'); ylabel('Mag. (dB)'); hold on
subplot(212); semilogx(w,ph,'k'); xlabel('Freq. (Hz)'); ylabel('Ph. (deg)');hold on

%complex freq response G (Transfer Function)-----
i = sqrt(-1);
for k =1:length(w)
    a = 10^(mag(k)/20)*cos(ph(k)*pi/180);
    b = 10^(mag(k)/20)*sin(ph(k)*pi/180);
    G(k,1) = a+b*i; % the Transfer Function of system
end

% make G even and get G_jq (conjugate of G)------
w = [0;w];
G = [G(1); G]; % Even G
G_jq = conj(G); % The conjugate of the even TF (G)
ome_g = w*2*pi; % get the omega of G_ff and G

% Create your optimal inversion code below -- please follow the process flow described in homework.
%Step 1
%Compute Optimal Inversion of Transfer Function
Q(0<=w & w<130) = 1;
Q(w>130) = 0;
R(0<w & w<130) = 0;
R(w>130) = 1;
Q = Q';
R = R';

%Calculate Optimal Inversion Transfer Function
for i = 1:length(w)
    Gff(i,1) = (G_jq(i)*Q(i))/(R(i) + G_jq(i)*Q(i)*G(i));
end

% Step 2
% Cleaning up Yd for fft

[Mag, Phase, freq, Yd_FFT] = fft_sample(yd, 500);
figure
plot(freq,Mag)

G_interp = interp1(ome_g, G, freq*2*pi, "linear",0);
Gff_interp = interp1(ome_g, Gff, freq*2*pi, "linear",0);

G_Full = [G_interp,flip(conj(G_interp(1:end-1)))];
Gff_Full = [Gff_interp,flip(conj(Gff_interp(1:end-1)))];

Uopt_jw = Gff_Full .* Yd_FFT;
Yopt_jw = G_Full .* Uopt_jw;

uopt = real(ifft(Uopt_jw));
yd_opt = real(ifft(Yopt_jw));

numSec = 3/SignalFreq;

[~,cycIdx1] = min(abs(t-(tend-numSec)));
[~,cycIdx2] = min(abs(t-(tend)));

figure
subplot(2,1,1)
hold on
plot(t(cycIdx1:cycIdx2), yd(cycIdx1:cycIdx2), "k")
plot(t(cycIdx1:cycIdx2), yd_opt(cycIdx1:cycIdx2), "--r")
legend("$y_d(t)$", "$y_{opt}(t)$", "Interpreter", "Latex")
xlabel("Time"); ylabel("Respone"); title("Desired and Optimal Trajectory vs Time [18 Hz Signal]")
subplot(2,1,2)
plot(t(cycIdx1:cycIdx2),uopt(cycIdx1:cycIdx2))
xlabel("Time"); ylabel("Input"); title("Optimal Input vs Time [18 Hz Signal]")