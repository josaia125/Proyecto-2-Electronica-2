%% =====================================================
%  CÁLCULOS DEL PRE-AMPLIFICADOR
%  Configuración: Drenaje Común (Source Follower)
%  Transistor: JFET 2N5457
% ======================================================

clc; clear; close all;

%% --- PARÁMETROS DEL JFET J111 ---
IDSS = 3e-3;       % Corriente de saturación [A] = 5 mA
VP   = -3;         % Tensión de pinch-off [V]
VDD  = 18;         % Tensión de alimentación [V]

%% =============================
%  1) PUNTO DE OPERACIÓN (DC)
% ==============================

IDQ  = IDSS / 2;
fprintf('=== PUNTO Q ===\n');
fprintf('IDQ  = %.2f mA\n', IDQ*1e3);

VGSQ = 0.3 * VP;
fprintf('VGSQ = %.2f V  (~-1 V)\n', VGSQ);

VDS  = VDD / 2;
fprintf('VDS  = %.2f V\n\n', VDS);

%% =============================
%  TRANSCONDUCTANCIA gm
% ==============================

gmo = (2 * IDSS) / abs(VP);
gm  = gmo * (1 - VGSQ/VP);
fprintf('=== TRANSCONDUCTANCIA ===\n');
fprintf('gmo = %.4f mS\n', gmo*1e3);
fprintf('gm  = %.4f mS\n\n', gm*1e3);

%% =============================
%  2) RESISTENCIA RS
% ==============================

% En Drenaje Común no existe RD → RD = 0
RS = (VDD - VDS) / IDQ;
fprintf('=== RESISTENCIAS ===\n');
fprintf('RS = %.0f Ω\n\n', RS);

%% =============================
%  CAPACITORES DE ACOPLE (f = 20 Hz)
% ==============================

f    = 20;           % Frecuencia mínima [Hz]
Rent = 221e3;          % Resistencia de entrada = Rg = 1 MΩ
RL   = 70e3;         % Resistencia de carga = Rent TDA2005 (modo estéreo)

C_entrada = 1 / (2*pi*f*Rent);
C_salida  = 1 / (2*pi*f*RL);

fprintf('=== CAPACITORES DE ACOPLE ===\n');
fprintf('C_entrada >= %.2f nF  → C elegido = 2.2 µF\n', C_entrada*1e9);
fprintf('C_salida  >= %.4f µF  → C elegido = 2.2 µF\n\n', C_salida*1e6);

C_acople_entrada = 2.2e-6;   % Valor comercial elegido
C_acople_salida  = 2.2e-6;

%% =============================
%  ANÁLISIS AC
% ==============================

Rg = Rent;                   % Rg = 1 MΩ
RS_prima = (RS * RL) / (RS + RL);   % RS // RL

fprintf('=== ANÁLISIS AC ===\n');
fprintf('RS'' = RS // RL = %.2f Ω\n', RS_prima);

% Ganancia de voltaje
Av = (gm * RS_prima) / (1 + gm * RS_prima);
fprintf('Av  = %.4f  (~0.88)\n', Av);

% Impedancias
Zin  = Rg;
Zout = RS_prima;
fprintf('Zin  = %.2f MΩ\n', Zin/1e6);
fprintf('Zout = %.2f Ω\n\n', Zout);

%% =============================
%  GANANCIA DE CORRIENTE
% ==============================

Ai = Av * (Rg / RL);
fprintf('=== GANANCIA DE CORRIENTE ===\n');
fprintf('Ai = %.4f  \n\n', Ai);

%% =============================
%  RESUMEN FINAL
% ==============================

fprintf('========== RESUMEN ==========\n');
fprintf('IDQ   = %.2f  mA\n',  IDQ*1e3);
fprintf('VGSQ  = %.2f  V\n',   VGSQ);
fprintf('VDS   = %.2f  V\n',   VDS);
fprintf('gm    = %.4f mS\n',   gm*1e3);
fprintf('RS    = %.0f  Ω\n',   RS);
fprintf('Av    = %.4f\n',      Av);
fprintf('Ai    = %.4f\n',      Ai);
fprintf('Zin   = %.1f  MΩ\n',  Zin/1e6);
fprintf('Zout  = %.2f  Ω\n',   Zout);
fprintf('C_ent = 2.2 µF\n');
fprintf('C_sal = 2.2 µF\n');
fprintf('==============================\n');
