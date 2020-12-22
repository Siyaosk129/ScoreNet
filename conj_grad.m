function [x_update,lambda,beta,s,FLAG]= conj_grad(Z_train,x,y_train,loss,gradx,s,n_sam_rec,w,loss_name)
lambda = 2; % Initial step length
mu=1e-4; FLAG = true;
beta = 0;
if norm(gradx) <= 1e-6 % Stopping criteria
    x_update = x;
    FLAG = false;
else
    while true % inexact line search
        x_update = x+lambda*s;
        a1 = x_update(1:w);
        a2 = x_update(w+1:2*w);
        a3 = x_update(2*w+1);
        a4 = x_update(2*w+2);
        b1 = x_update(2*w+3);
        b2 = x_update(2*w+4);
        b3 = x_update(2*w+5);
        b4 = x_update(2*w+6);
        model = struct();
        model.a1 = a1; model.a2 = a2; model.a3 = a3; model.a4 = a4;
        model.b1 = b1; model.b2 = b2; model.b3 = b3; model.b4 = b4;
        model.w = w;
        [yhat,cand_train,score_train,out_gate_train,idx_on_train,idx_off_train] = forward_compute(Z_train,model,n_sam_rec);
        [loss_new, dyhat] = loss_grad(yhat,y_train,loss_name);
        gradx_new = gradient_update(Z_train,dyhat,yhat,out_gate_train,cand_train,score_train,idx_on_train,idx_off_train,model);
        if loss_new - loss - mu*lambda*(s'*gradx) <= 0
            %             beta = gradx_new'*(gradx_new-gradx)/(s'*(gradx_new-gradx)); % HS formula
            beta = gradx_new'*(gradx_new-gradx)/(gradx'*gradx); % PR formula
            %             beta = (gradx_new'*gradx_new)/(gradx'*gradx); % HS formula
            s = -gradx_new+beta*s;
            break;
        else
            lambda = lambda*0.9;
        end
        if lambda <=1e-8
            FLAG = false;
            break;
        end
    end
    
end

end