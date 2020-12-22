function [loss,grad] = loss_grad(yhat,y,loss_name)
% This funciton is for calculation of loss function and its gradient
% w.r.t. yhat.
% Args:
%     yhat: array of predictions
%     y: array of labels
%     loss_name: name of loss function to be used
% Returns:
%     loss: value of the cost function
%     grad: gradient w.r.t. yhat in array
    
if strcmp(loss_name,'ent') % Entropy
    loss = -(y*log(yhat)'+(1-y)*log(1-yhat)')/length(y);
    grad = (yhat-y)./(yhat.*(1-yhat))/length(y);
elseif strcmp(loss_name,'softdl') % Soft dice
    intersec = y*yhat';
    union = sum(y+yhat);
    loss = 1-(2*intersec)/union;
    grad = -2*(y*union-intersec)/(union^2);
elseif strcmp(loss_name,'sqdl') % Square dice
    intersec = y*yhat';
    union = y*y'+yhat*yhat';
    loss = 1-(2*intersec)/union;
    grad = -2*(y*union-2*yhat*intersec)/(union^2);
elseif strcmp(loss_name,'logdl') % Log dice
    intersec = y*log(1-yhat)';
    union = 2*y*log(1-yhat)'+(1-y)*log(1-yhat)'+y*log(yhat)';
    loss = 1-2*intersec/union;
    grad = 2*(y.*yhat*union+(y-yhat-2*y.*yhat)*intersec)./(yhat.*(1-yhat)*union^2);
end
end