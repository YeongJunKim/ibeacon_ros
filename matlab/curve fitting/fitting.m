% https://kr.mathworks.com/help/curvefit/custom-nonlinear-census-analysis.html

s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[Inf,max(cdate)],...
               'Startpoint',[1 1]);
f = fittype('a*(x-b)^n','problem','n','options',s);
[c2,gof2] = fit(cdate,pop,f,'problem',2)
[c3,gof3] = fit(cdate,pop,f,'problem',3)
plot(c2,'m'); hold on
plot(c3,'c')
legend( 'fit with n=2', 'fit with n=3' )