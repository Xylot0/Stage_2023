function [reg,xlds,ylds,wts,xscrs,ncomp,siglist]= wrtpls(x,y,options)
%+++ WEIGHT RANDOMIZATION TEST FOR NUMBER OF PLS COMPONENTS proposed by Thanh N. Tran et al.
% [reg,xlds,ylds,wts,xscrs,ncomp,siglist]= wrtpls(x,y,options)
% Input:
%   x: nxd data matrix
%   y: nx1 sigle response variable
%   options.figON: plots statistis of all componets (default = 0, set to 1 for the plots)
%   options.numnonsigs: Number of nonsignificant comps in a row #nonsignificant components (default = 3)
%   options.permn: Number of permutations (default = 2000)
%   options.dist: 'Lognormal' or 'Nakagami' (default = 'Lognormal')
%   options.alpha: confidence level (default value = 0.05)
% Output: [reg,xlds,ylds,wts,xscrs,ncomp]
%   reg: regression coefficients
%   xlds: X-loading
%   ylds: Y-loading
%   wts: X-weight
%   xscrs: X-score
%   ncomp: final number of PLS components
% Example:
%   load spectra
%   x = NIR;
%   y = octane;
%
% Get default options
% options = wrtpls('options');
% Run WRTPLS with default options
%[reg,xlds,ylds,wts,xscrs,ncomp] = wrtpls(x,y,options);
%
% Customized options
% options = wrtpls('options');
% options.figON = 1;
% options.numnonsigs = 1;
% options.maxcomp = 25;
% [reg,xlds,ylds,wts,xscrs,ncomp] = wrtpls(x,y,options);
%
% In case of publication of any application of this method,
% please, cite the original work:
% Thanh Tran, Ewa Szyma?ska, Jan Gerretzen, Lutgarde Buydens, Nelson Lee
% Afanador, Lionel Blanchet, Weight randomization test for the selection of
% the number of components in PLS models, Journal of Chemometrics. 2017;e2887.
% DOI: https://doi.org/10.1002/cem.2887
% -----
% Thanh N. Tran, Ph.D. 
% Radboud University Nijmegen
% Institute for Molecules and Materials, Analytical Chemistry & Chemometrics
% EXAMPLE: on Octane NIR data, Kalivas, J. H., Two data sets of near infrared spectra. Chemom. Intell. Lab. Syst. 1997, 37
% load spectra
% xorg = NIR;
% y = octane;
% wavelength=900 : 2:1700;
% x = NIR;
% y = octane;
% x = bsxfun(@minus,x,mean(x));
% y = bsxfun(@minus,y,mean(y));
% options = wrtpls('options');
% With default options
% [reg,xlds,ylds,wts,xscrs,ncomp] = wrtpls(x,y,options);
% With non-default options
% options = wrtpls('options');
% options.figON = 1;
% options.numnonsigs = 1;
% options.maxcomp = 25;
% [reg,xlds,ylds,wts,xscrs,ncomp] = wrtpls(x,y,options);
if size(x,1) == 1 && strcmp(x,'options') %Options
    % Permutation size    
    options.permn = 2000;
    options.dist = 'Lognormal';
    % Set maximum number of components
    options.maxcomp = [];
    options.figON = 0;
    options.alpha = 0.05;
    % Number of nonsignificant comps in a row 
    options.numnonsigs = 3;
    reg = options;
    return;
elseif nargin > 3
    error('Input parameters invalid')
    return;
end
    % Sample size x Variable size
    [n d] = size(x); 
    % Set maximum number of components
    if isempty(options.maxcomp) %#ok<EXIST>
        options.maxcomp = min(n,d);
    end
        
    % Initialize for permutation
    reg = []; xlds = []; ylds=[]; wts=[]; xscrs = [];
    nsiga = 0; % nonsignificant comps 
    
    % a faster implementation
    randpermindex = cell2mat(arrayfun(@(dummy) randperm(n), 1:options.permn, 'UniformOutput', false)');
     % PLS
    xdef = x;
    ydef = y;
    ncomp = 0;
    dul=[];
    siglist=[];
    stdecv_=inf;
    % For each component entering the model
    for a = 1:options.maxcomp,
        % Orginary PLS algorithm
        v = xdef'*ydef;            % original y instead of ydef
        w(:,a) = v/sqrt(v'*v);
        t(:,a) = xdef*w(:,a);
        tt = t(:,a)'*t(:,a);
        p(:,a) = xdef'*t(:,a)/tt;
        q(a,1) = t(:,a)'*y/tt;
          
        if options.maxcomp > ncomp
            % Observed (model) log norm of (non-normalized) weight
            %lognormwobs = log(sqrt(sum(v.^2))');
            normwobs = sqrt(sum(v.^2))';
            % Permutation response set
           yprm = ydef(randpermindex);
            % Permutation (non-normalized) weight set
            wprm = xdef' * yprm';
            
            normwprm = sqrt(sum(wprm.^2))';
    
            if strcmp(options.dist,'Lognormal')
                lognormwprm = log(normwprm);
                mlognormwprm = mean(lognormwprm);
                stdlognormwprm = std(lognormwprm);
                tcri = tinv((1-options.alpha),size(x,1)-1);
                CL(1) = exp(mlognormwprm - tcri*stdlognormwprm);
                CL(2) = exp(mlognormwprm + tcri*stdlognormwprm);
            else
                [parms ciparms] = mle(normwprm,'distribution',options.dist,'alpha',options.alpha*2);
                CL = icdf(options.dist,[options.alpha*2 1-(options.alpha*2)],parms(1),parms(2));
            end
            
            if options.figON        
                figure;histfit(normwprm,100,options.dist)                
                title(['LV: ' num2str(a) ' -Hist: Norm permutation weights / ' options.dist ' distribution']); 
                hold on;
                plot([normwobs normwobs],[0 options.permn/30],'g')
                plot([CL(1) CL(1)],[0  options.permn/30],'r')
                plot([CL(2) CL(2)],[0  options.permn/30],'r')
            end
            %if (lognormwobs > UL)
            if (normwobs > CL(2))                
                siglist(a) = 1;
                nsiga = 0;
            else
                siglist(a) = 0;
                nsiga = nsiga + 1;
                % Check for nonsignificant comps in a row 
                if nsiga >= options.numnonsigs
                    ncomp = a-options.numnonsigs;
                    break;
                end
            end
        end
            
        % Deflation x and y
        xdef = xdef-t(:,a)*p(:,a)';
        ydef = ydef-t(:,a)*q(a,1)';
    end
    
    if ncomp > 0,
        % Assign PLS output
        xscrs = t(:,1:ncomp);
        wts = w(:,1:ncomp);
        xlds = p(:,1:ncomp);
        ylds = q(1:ncomp,1);
        reg = cumsum(wts*(inv(xlds'*wts)*diag(ylds')),2);
        reg = reg(:,end);
    end
end
