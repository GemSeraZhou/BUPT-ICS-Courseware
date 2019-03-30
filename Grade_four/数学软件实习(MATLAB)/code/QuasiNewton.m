function [x,f,k,xiter]=QuasiNewton(fun,x0,epsilon)
%---------------------------------------------------------
% ��ţ�ٷ���� min f(x)
% fun ���㺯��
% x0 ��ʼ������
% epsilon �������
%��������ֵ��
%  f ����ֵ
%  k ��������
% ���ã� 
%[x,f,k,xiter]=QuasiNewton(@fun,[0,0]',0.001)
%[x,f,k,xiter]=QuasiNewton(@myrosenbrock,[0,0]',0.001)
%-------------------------------------------------------


k=0;  % ��������
rho=0.9;
beta=0.5;
tau=1;
nmax = 100;%��������̫��
mmax=30;
xiter=[x0' feval(fun,x0)];

syms a b
F = fun([a,b]);
v=[a,b];
grad=jacobian(F,v); %���ݶ�

Hk=eye(2);% ��ʼ�ľ���

while (k<nmax)
    
    gk=subs(grad,v,x0');%
    
    if norm(gk)<epsilon    
        break;     %һ�ױ�Ҫ������
    end
    
    
    dk= -Hk*(gk'); 
    m=0;  %���������ã�������׼��
          %   Wolfe ����׼��
    while (m<mmax)
        if feval(fun,(x0+(beta^m*tau*dk)))<feval(fun,x0)+(rho*beta^m*tau*dk'.*gk)
            break;
        end
        m=m+1;
    end
    mk=m;  
    x1=x0+(beta^mk*tau*dk);
    
    sk = x1 - x0;
    
    yk = subs(subs(grad,a,x1(1)),b,x1(2)) - subs(subs(grad,a,x0(1)),b,x0(2));
    yk=yk';
    
    %DFP ����
    Hk = Hk - (Hk*yk*yk'*Hk)./(yk'*Hk*yk)+(sk*sk')/(yk'*sk);
    
    x0=x1;
    
    f=feval(fun,x0);
    xiter=[xiter;x0' f];
    k=k+1;
end
x=x0;
%f=feval(fun,x0);
%plot3(xiter(:,1),xiter(:,2),xiter(:,3),'r*')
end
