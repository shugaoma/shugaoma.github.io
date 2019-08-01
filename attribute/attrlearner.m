function model = attrlearner(X,L,c, c2)
% This function discovers relative attributes.
%
% Input
% X: each row is a sample
% L: L(i) is the class label for X(i,:)
% c1: weight for loss term
% c2: weight for ratio of irrelevant classes
% (Note -- for more detail of c1 and c2, please refer to our paper.) 
% 
% Output
% model.w: learned projection line
% model.cls: list of classes in order. cls(i) > cls(i+1)      
%
% Author: Shugao Ma, 2012-1-27
% 
% Please cite the following paper if you use our code:
%
% Shugao Ma, Nazli Ikizler-Cinbis and Stan Sclaroff.
% "Unsupervised learning of discriminative relative visual attributes". 
% In 2nd International Workshop on Parts and Attributes, 
% held in conjunction with European Conference on Computer Vision 2012.

addpath('path to your liblinear matlab wrapper directory');

cls = unique(L);
ns = length(cls);
p1 = repmat(cls', ns, 1);
p1 = p1(:);
pair = [p1 repmat(cls, ns, 1)];
pair = pair(pair(:,1) < pair(:,2), :);

model = cell(size(pair, 1), 1);
for p = 1:size(pair,1)
    cls1 = pair(p, :)';
    prev_cls1 = [];
    w = [];
    score = 0;
    prevscore = 0;
    ind = 1;
    while length(cls1) < ns
        Xs = cell(length(cls1),1);
        ns1 = length(cls1);
        for i = 1:ns1
            Xs{i} = sparse(X(L==cls1(i),:));
        end
        [svmmodel, svmscore] = learnmodel(Xs, c);
        score = svmscore + c2 * (1-ns1/ns);
        if score > prevscore && ns1 ~= 2
            cls1 = prev_cls1; % return mu^(t-1)
            break;
        end
        w = svmmodel.w';
        if length(cls1) == ns
            break;
        end
        prev_cls1 = cls1;
        cls1 = findclass(w, X, L,cls,cls1);
        prevscore = score;
        ind = ind + 1;
    end
    model{p}.score = score;
    model{p}.w = w;
    model{p}.cls = cls1;
end

end

function updated_cls = findclass(w, X, L, cls, cls1)

cls2 = setdiff(cls, cls1);
for i = 1:length(cls1)
    m(i) = median(X(L==cls1(i), :)*w);
end
[m, idx] = sort(m);
%cls1 = cls1(idx(end:-1:1));
m = [-inf m inf];
m2 = zeros(length(cls2), 1);
e = zeros(length(cls2), 1);
for i = 1:length(cls2)
    x = X(L==cls2(i), :)*w;
    m2(i) = median(x);
    p = histc(x, m);
    p = p(1:end-1)/sum(p(1:end-1));
    e(i) = -sum(p(p~=0).*log(p(p~=0)));
end

[minE, id] = min(e);
m = m(end:-1:1);
for i = 1:length(cls1)+1
    if m2(id) < m(i) && m2(id) >= m(i+1)
        if i == 1
            updated_cls = [cls2(id);cls1];
            return;
        end
        if i == length(cls1)+1
            updated_cls = [cls1;cls2(id)];
            return
        end
        updated_cls = [cls1(1:i-1);cls2(id);cls1(i:end)];
        return;
    end
end
end


function [model, score] = learnmodel(X,c)
% Construct a one class SVM.
% X is a matrix cell. X{i} contains of sample from class i. attr order: i > j
% difference vectors as training vectors
d = size(X{1},2);
A = [];
for i = 1:length(X)-1
    n = size(X{i}, 1);
    n2 = size(X{i+1}, 1);
    idx = repmat(1:n, n2, 1);
    idx = idx(:);
    A = [A; X{i}(idx,:) - repmat(X{i+1}, n, 1)];
end
n = size(A, 1);
Y = ones(n, 1);
model = train(Y, sparse(A), ['-s 1 -c ' num2str(c)]);
loss = max(0, (1 - Y.*(A*model.w')));
score = sum(model.w .* model.w)/2 + c * sum(loss.*loss);
end