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
close all
%% Create your optimal inversion code below -- please follow the process flow described in homework.

%Step 1
%Compute Optimal Inversion of Transfer Function
Q(0<w & w<130) = 1;
Q(w>130) = 0;
R(0<w & w<130) = 0;
R(w>130) = 1;

for i = 1:length(w)
    Gff(i) = (G_jq(i)*Q(i))/(R(i) + G_jq(i)*Q(i)*G(i));
end

N = length(yd);
Fs = SamplingFreq;
omega = 2*pi*(0:N-1)*(Fs/N);   % rad/s

G_real = interp1(ome_g, real(G), omega, 'linear', 0);
G_imag = interp1(ome_g, imag(G), omega, 'linear', 0);
G_interp = G_real + 1i*G_imag;

Gff_real = interp1(ome_g, real(Gff), omega, 'linear', 0);
Gff_imag = interp1(ome_g, imag(Gff), omega, 'linear', 0);
Gff_interp = Gff_real + 1i*Gff_imag;

%Step 2
% Comput FFT of Yd
Yd_jw = fft(yd);

for i = 1:length(Gff_interp)
    Uopt_jw(i) = Gff_interp(i) * Yd_jw(i);
    Yopt_jw(i) = G_interp(i) * Uopt_jw(i);
end

yopt = ifft(Yopt_jw);


