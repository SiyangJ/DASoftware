function [da,fw]=main(filename)
% Description:
% function [sol,stats] = main(filename)
% input: filename of input selected by users
% output:
% check input type
if isa(filename,'char')
    % Convert information from txt into a structure "param"
    param=get_prm(filename);
elseif isa(filename,'struct')
    param = filename;
else
    error('input must be a filename or a structure');
end

% TODO: add other parameters specifed by users:
% total simulation step
% translate kernel type in .txt file to "param"
% param.kernel = @(h) param.x_std.*exp(-(h./(20/3))); % x_std is the variance


%% Initialization
% Map simulation parameters to FW subclass and create an object at time 0
fw = selectFW(param);
% file = load('ini.mat');
% fw.xt = file.xt;
% Map inversion parameters to DA subclass and create an object at time 0
da = selectDA(param,fw);

% TODO: check if fw and da contain all the necessary properties and functions after initialization
rng(100);

da_list = cell(param.nt+1,1);
fw_list = cell(param.nt+1,1);

% major assimilation loop
for i = 1:param.nt
    %% Run truemodel to produce true state xt and data z, save as property of fw
    % call f and h to update state and observation
    [fw.xt, fw.zt] = fw.simulate(fw.xt);
    
    %% Run data assimilation to get solution x and its uncertainty, save as property of da
    % KF forecast
    da.predict(fw);
    da.update(fw);
    
    da_list{i}  = da;
    fw_list{i}  = fw;
    % save fw and da as snapshots for analysis
    
end

end
