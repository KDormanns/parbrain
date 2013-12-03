%% Demand and supply experiment
% First create a tree - maybe 13 levels is adequate
S = TreeSimulator('N', 13, 'RMULT', sqrt(2));
[fnvu, params] = nvu('REGDISABLE', true);
% Connect the pieces up
S.fnvu = fnvu;
S.nnvu = params.nVars;
S.fp0 = @(t) ones(size(t));

% Right, nice and boring :)
% Compute an initial condition
[u0, success] = S.computeeq(repmat(0.5, S.nnvu * S.nBlocks, 1));
%%
iSMC = params.iSMC:params.nVars:(S.nnvu*S.nBlocks); 
uh = u0;
uh(iSMC(1)) = 0;
[u, success] = S.computeeq(uh);



%%

S.tree.setconductance(u0(1:S.nnvu:end).^4, 1:S.nBlocks);
S.tree.solve(1, S.pcap);
q0 = S.tree.q(1:S.nBlocks);

x = S.tree.X(1:S.nBlocks);
y = S.tree.Y(1:S.nBlocks);
x = x(:); y = y(:);
Area = linspace(0, 5e-3, 10);
iSMC = params.iSMC:S.nnvu:numel(u);
q = zeros(numel(Area), S.nBlocks);
fprintf('RMULT: %.2f:  ', S.RMULT)
for i = 1:numel(Area)
    idx = find(x.^2 + y.^2 <= Area(i)^2);
    u0(iSMC(idx)) = 0;
    [T, U] = ode15s(f, [0 500], u0, opts);
    u = U(end, :);
    S.tree.setconductance(u(1:S.nnvu:end).^4, 1:S.nBlocks);
    S.tree.solve(1, S.pcap);
    q(i, :) = S.tree.q(1:S.nBlocks);
    fprintf('%-8.4f', max(q(i, :)));
end
fprintf('\n')








% First experiment - from one corner
area = 1; % 1 block




