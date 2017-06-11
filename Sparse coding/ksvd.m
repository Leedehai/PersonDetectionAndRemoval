function dict = ksvd(dict,Y,rc_min,max_coeff,sigma,max_iter)

% perform ksvd based on OMP
% object function: min_{dict,A} \sum_{j=1}^{numOfSignal}||dict*a_j-Y||_2^2
%                  s.t. norm(a_j,0)<=max_coeff (norm(a,0) denotes the l_0 norm of vector a)
% Author: Chen Zhu
% 2017-3-14

% INPUT:
% dict: (N,numOfAtom), initialized dictionary
% Y: (N,numOfSignal), degraded image split into a matrix (see splitImg.m)
% rc_min: OMP parameter, minimal residual correlation before stopping
% max_coeff: OMP parameter, maximal number of non-zero coefficients for signal
% max_iter: maximum number of iterations of ksvd update

% OUTPUT:
% dict: learned dictionary



[N,numOfSignal] = size(Y);
[~,numOfAtom] = size(dict);
% initialize sparse matrix A
A = zeros(numOfAtom,numOfSignal);
% residual term
res = norm(Y-dict*A);
% Initizlize X = dict*A
X = dict*A;
M = ones(size(Y));

iter = 0;

while(iter<max_iter)
    if(mod(iter,5)==0)
        display(strcat(' computing ksvd: current iter ',num2str(iter),...
            ' res: ',num2str(norm(res))));
    end % if
    iter = iter + 1;
    % first stage update: pursuit algorithm
    A =  OMP(dict, Y, M, sigma, rc_min, max_coeff);
    
    % second stage update: update dictionary, column by column svd
    for j=1:numOfAtom
        index = find(A(j,:)~=0);
        if(isempty(index))
            continue;
        end %if
        % compute error matrix E
        dict(:,j) = 0;
        E = Y(:,index) - dict*A(:,index);
        [U,s,V] = svd(E);
        dict(:,j) = U(:,1);
        A(j,index) = s(1,1)*V(:,1);
    end %for
    X_new = dict*A;
    res = Y-X_new;
    X = X_new;
end %while

