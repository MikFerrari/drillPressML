function [mean_vec] = mediacomplex(vec)
%[mean_vec]=mediacomplex(vec) vec è un vettore di numeri complessi; mean_vec
%è un numero complesso che ha come parte reale la media delle parti
%reali e come parte immaginaria la media delle parti immaginarie.
mean_real=mean(real(vec));
mean_img=mean(imag(vec));
mean_vec=mean_real+mean_img*i;
end

