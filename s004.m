function s004()
% Economic parameters
n=4;
m=ones(n,1)*100;
pc=1; pd=1; pl=1.3;
b=0.2;
a=[0.9 1.5 1.2 1.3]';

% Cobb-Douglas
k3=[0.1 0.2 0.1 0.3];
k2=[0.5 0.4 0.5 0.3];
k1=1-k2-k3;

% Others
r=0.5; % rho
iter=n; % #iteration = #players works well

% Store original values
m0=m; pc0=pc; pd0=pd; pl0=pl; b0=b; a0=a;

%%%%%%%%%%%%%%%%%%%%
h('Benchmark');
%%%%%%%%%%%%%%%%%%%%
% Initialization
u=zeros(n,1);
X=zeros(n,1);
Y=zeros(n,1);
cdl=zeros(n,3);

find_NE
x=m-cdl*[pc pd pl]';
Z1=Z
result1=[m x cdl -u]

%%%%%%%%%%%%%%%%%%%%
h('Price of conventional');
%%%%%%%%%%%%%%%%%%%%
pc=pc0*1.01; % 1% up
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z2=Z
result2=[m x cdl -u]
pc=pc0;

%%%%%%%%%%%%%%%%%%%%
h('Price of donation');
%%%%%%%%%%%%%%%%%%%%
pd=pd0*1.01; % 1% up
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z3=Z
result3=[m x cdl -u]
pd=pd0;

%%%%%%%%%%%%%%%%%%%%
h('Price of local');
%%%%%%%%%%%%%%%%%%%%
% pl=pl0*1.01; % 1% up
pl=pl0*0.99; % 1% down
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z4=Z
result4=[m x cdl -u]
pl=pl0;

%%%%%%%%%%%%%%%%%%%%
h('Alpha');
%%%%%%%%%%%%%%%%%%%%
a(3)=a0(3)*1.01; % 1% up
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z5=Z
result5=[m x cdl -u]
a(3)=a0(3);

%%%%%%%%%%%%%%%%%%%%
h('Beta');
%%%%%%%%%%%%%%%%%%%%
b=b0*1.01; % 1% up
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z6=Z
result6=[m x cdl -u]
b=b0;

%%%%%%%%%%%%%%%%%%%%
h('Income');
%%%%%%%%%%%%%%%%%%%%
m(4)=m0(4)*1.01; % 1% up
initialize
find_NE
x=m-cdl*[pc pd pl]';
Z7=Z
result7=[m x cdl -u]
m(4)=m0(4);

%%%%%%%%%%%%%%%%%%%%
% Functions
%%%%%%%%%%%%%%%%%%%%
function find_NE() % Locate the NE
  for cnt=1:iter
    for i=1:n
      lb=[0 0 0];
      ub=[m(i)/pc m(i)/pd m(i)/pl];
      s0=lb; % not sensitive
      options=optimset('Algorithm','interior-point','Display','off');
      [cdl(i,:),u(i)]=fmincon(@umax,s0,[],[],[],[],lb,ub,[],options);
    end
  end

  function uu=umax(var) % Individual optimization
    cdl(i,:)=var;
    c=var(1);
    d=var(2);
    l=var(3);
    X=m(i)-pc*c-pd*d-pl*l;
    Y=c+a(i)*l;
    Z=aggregator(cdl(:,2)+b*cdl(:,3));
    uu=-((X^k1(i))*(Y^k2(i))*(Z^k3(i)));
  end
end

function ZZ=aggregator(s) % s: n-vector
  ZZ=sum(s.^r)^(1/r);
end

function initialize()
  u=zeros(n,1);
  X=zeros(n,1);
  Y=zeros(n,1);
  cdl=zeros(n,3);
end

function h(hmsg) % Generate a heading
  disp(sprintf(strcat('\n\n','***',hmsg,'***')) )
end
end
