function [rx_pow] = RSS_uniform(led_loc, client_loc, client_or)
load global_params.mat;

del_h = led_height - client_height;
dist_3d = pdist([led_loc;client_loc],'euclidean');
dist_xy = pdist([led_loc(1:2);client_loc(1:2)],'euclidean');
irrad = atan(del_h/dist_xy);
incidence = pi/2 - irrad - (client_or + pi/2);

rx_pow = P_max*(m_uniform + 1)*(cos(irrad)^m_uniform)*cos(incidence)/(dist_3d^2*2*pi);

end

